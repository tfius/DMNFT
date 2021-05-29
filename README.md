# DMTNFT
Value Carry NFT DataMarket Factory

DMT is ERC20 Token that can Mint NFT with value
- Starts with 0 supply
- Buy token with ETH
- Sell token to get back ETH 
- Mint nft with value and metadata location and data location in Swarm 
- Issue challenges for NFT and data location
- Validators can slash NFT token values 
- NFT owners can mint DMT token for amount it was minted and exchange it to ETH
- data locations can now carry value

To deploy: 
 - depoly Collection first, get address
 - deploy DMT token with Collection contract address to link them together 
 - call Collection.setMinter with address of DMT 
 - now DMT can mint NFTs in Collection 
 - 0.05% of buys and sells go to DMT treasury 
   
Depoloyed on Polygon
MetaNFT at 0xE1B74966fFBf19A7360bCE9bc1D86c7546D09EE2
DMTNFT at 0x7eF94f51a5355456e498d7643967D63e766eFcE2 

MetaNFT points to metadata location and data location as bytes32, it's location should be on Swarm or IPFS. 
