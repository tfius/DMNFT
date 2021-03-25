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
   
Because I am not completly sure if everything is inlined with cryptoeconomics, I am publishing it and i am open for discussion. 
No nada. No tests, as is, alpha, not even beta. For your consideration. 

Do not use in production. 
