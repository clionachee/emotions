
import NFTStore from 0x05

pub fun main(address: Address): [UInt64] {
  let userAccount = getAccount(address)

  let collection = userAccount.getCapability<&NFTStore.NFTCollection{NFTStore.NFTCollectionPublic}>(/public/NFTStore).borrow() ?? panic("No NFT")

  let ids = collection.getIDs()
  log(ids)

  return ids
}