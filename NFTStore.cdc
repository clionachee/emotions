
pub contract NFTStore {
    pub let CollectionStoragePath: StoragePath;
    pub let CollectionPublicPath: PublicPath;

    // Initialize the contract with love
    init() {
        self.CollectionStoragePath = StoragePath(identifier: "NFTStore")!
        self.CollectionPublicPath = PublicPath(identifier: "NFTStore")!

        self.account.save<@NFTCollection>(
            <- self.createEmptyCollection(),
            to: self.CollectionStoragePath
        )
    }

    // NFT structure
    pub resource NFT {
        pub var emotion: String
        pub var description: String

        init(emotion: String, description: String) {
            self.emotion = emotion
            self.description = description
        }
    }

    pub resource interface NFTCollectionPublic {
        pub fun deposit(nft: @NFT);
        pub fun getIDs(): [UInt64];
        pub fun borrowNFT(id: UInt64): &NFT;
    }

    // Collection of NFTs
    pub resource NFTCollection: NFTCollectionPublic {
        pub var nfts: @{UInt64: NFT}
        pub var supply: UInt64

        init() {
            self.nfts <- {}
            self.supply = 0
        }

        pub fun deposit(nft: @NFT) {
            self.nfts[nft.uuid] <-! nft
            self.supply = self.supply + 1
        }

        pub fun getIDs(): [UInt64] {
            return self.nfts.keys
        }

        pub fun borrowNFT(id: UInt64): &NFT {
            let nft = (&self.nfts[id] as auth &NFT?)

            if nft == nil {
                panic("Invalid ID")
            }

            return nft!
        }

        pub fun withdraw(id: UInt64): @NFT {
            let nft <- self.nfts.remove(key: id) ?? panic("Invalid ID")
            return <- nft
        }

        destroy() {
            destroy self.nfts;
        }
    }

    // When the lovely User XYZ may want to mint their very first NFT
    // They first must create an NFT Collection in their account
    // So that the NFT can be minted inside of that collection
    pub fun createEmptyCollection(): @NFTCollection {
        return <-create NFTCollection()
    }

    // Mint a new NFT
    // Create a new NFT resource and save it inside the user's
    // NFT Collection Resource
    pub fun mintNFT(emotion: String, description: String): @NFT {
        let newNFT <- create NFT(
            emotion: emotion,
            description: description
        )
        return <-newNFT
    }
}