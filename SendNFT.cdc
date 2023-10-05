
import NFTStore from 0x05

transaction(recipient: Address, nftId: UInt64) {
  prepare(acct: AuthAccount) {
    // 1. Withdraw NFT from our private collection
    let collection <- acct.load<@NFTStore.NFTCollection>(from: NFTStore.CollectionStoragePath)
        ?? panic("You dont have any NFTs to send")
        
    let nft <- collection.withdraw(id: nftId)

    // 2. Get capability to recipient collection
    let receiverCollectionCapability = getAccount(recipient)
        .getCapability(/public/NFTStore)
        .borrow<&NFTStore.NFTCollection{NFTStore.NFTCollectionPublic}>() ?? panic("Recipient does not have collection to receive NFTs")

    // 3. Deposit NFT to recipient collection
    receiverCollectionCapability.deposit(nft: <- nft)

    // Save our collection back where it came from
    acct.save(<- collection, to: NFTStore.CollectionStoragePath)
  }
}
