using DapperLabs.Flow.Sdk.Unity;
using UnityEngine;

public class CadenceL : MonoBehaviour
{
    public static CadenceL Instance { get; private set; }

    [Header("Contracts")]
    public CadenceContractAsset NFTStore;

    [Header("Transactions")]
    public CadenceTransactionAsset MintNFTfromNFTStore;
    public CadenceTransactionAsset SendNFT;

    [Header("Scripts")]
    public CadenceScriptAsset GetAllNFTIDs;
    public CadenceScriptAsset GetSpecificNFTInfo;

    void Awake()
    {
        if (Instance != null && Instance != this) Destroy(this.gameObject);
        else Instance = this;
    }
}
