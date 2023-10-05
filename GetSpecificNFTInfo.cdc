
import NFTStore from 0x05

pub fun main(address: Address, id: UInt64): &NFTStore.NFT {
  let userAccount = getAccount(address)

  let collection = userAccount.getCapability<&NFTStore.NFTCollection{NFTStore.NFTCollectionPublic}>(/public/NFTStore).borrow() ?? panic("No NFT")

  let nft = collection.borrowNFT(id: id)

  log(nft.emotion)
  log(nft.description)

  return nft
}