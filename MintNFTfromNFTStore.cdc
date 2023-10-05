
import NFTStore from 0x05

transaction(emotion: String, description: String) {
  prepare(acct: AuthAccount) {
  
    // 1. Mint a new NFT
    let nft <- NFTStore.mintNFT(emotion: emotion, description: description)

    // 2. Attempt to get our OWN collection
    let capability = acct.getCapability(/public/NFTStore).borrow<&NFTStore.NFTCollection{NFTStore.NFTCollectionPublic}>()

    // If we already have an existing collection, just deposit the NFT to the collection
    if capability != nil {
      // Deposit
      capability!.deposit(nft: <- nft)
    } 
    // If we don't already have an existing collection, we must make one first before depositing the NFT
    else {
      // Create a new collection and then deposit
      let emptyCollection <- NFTStore.createEmptyCollection()

      // Deposit
      emptyCollection.deposit(nft: <- nft)

      // Save the newly created collection
      acct.save(<- emptyCollection, to: NFTStore.CollectionStoragePath)
      acct.link<&NFTStore.NFTCollection{NFTStore.NFTCollectionPublic}>(/public/NFTStore, target: NFTStore.CollectionStoragePath)
    }
  }
}