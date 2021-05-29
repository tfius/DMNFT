// "SPDX-License-Identifier: MIT"
// TEX 22.09.2020
pragma solidity ^0.8.4;
//pragma abicoder v2;
//pragma abiencoder v2;

// Polygon
// MetaNFT at 0xE1B74966fFBf19A7360bCE9bc1D86c7546D09EE2  (TxHash: 0xab87a9c1d4ec860de55cebf167d734d94ecc0865d3b80ce3426162dec2acac46)
// DMTNFT at 0x7eF94f51a5355456e498d7643967D63e766eFcE2  (TxHash: 0x7a3b9f858eb8e2bb2d0b892272022d50190b98abbca2bd9dab9fe42db58aaeb7)

library Address {
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    assembly { size := extcodesize(account) }
    return size > 0;
  }
}
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;
    return c;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}
library Strings {
    bytes16 private constant alphabet = "0123456789abcdef";
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
/* Interface of the ERC20 standard as defined in the EIP. */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
/* Interface for the optional metadata functions from the ERC20 standard. */
interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}
interface IERC721Metadata is IERC721 {
   function name() external view returns (string memory);
   function symbol() external view returns (string memory);
   function tokenURI(uint256 tokenId) external view returns (string memory);
}
interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {

    /* @dev Returns the total amount of tokens stored by the contract.*/
    function totalSupply() external view returns (uint256);

    /* @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens. */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /* @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens. */
    function tokenByIndex(uint256 index) external view returns (uint256);
}
/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract NFTCollection is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using SafeMath for uint256;
    using Address for address;
    using Strings for uint256;
    using Counters for Counters.Counter;
    
    address payable contractOwner;
    address payable contractMinter;

    // Token name
    string private _name;
    // Token symbol
    string private _symbol;
    // Price of Symbol
    uint256 private _creationPrice = 10000000; // 10 gwei
    // Metadata location on swarm
    bytes32 private collectionMetadataLocation; 
    
    // Mapping from token ID to owner address
    mapping (uint256 => address) private _owners;
    // Mapping owner address to token count
    mapping (address => uint256) private _balances;
    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;
    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    
     // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) internal ownedTokens; 
    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) internal ownedTokensIndex;    
    // Mapping from owner to number of owned token
    mapping (address => uint256) internal ownedTokensCount;
    
    // Mapping from tokenId to swarm location 
    mapping (uint256 => bytes32) internal _tokenDataLocation;
    mapping (uint256 => bytes32) internal _metadataLocation;
    mapping (uint256 => address) internal _tokenCreator;
    mapping (uint256 => uint256) internal _tokenAmount;
    mapping (uint256 => uint256) internal _tokenChallenged; // for how much it is challenged

    // Mapping from swarmLocation to tokenId, data hash to tokenId
    mapping (bytes32 => uint256) internal tokenDataToToken;  
    // Mapping from swarmLocation to first claimer, data swarm location to claimer
    // mapping (bytes32 => address) internal swarmLocationToClaimer;    
    
    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;
    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private allTokensIndex;
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;    
    Counters.Counter private _tokenIdTracker;
    //uint256 tokenCounter;
    
    /* @dev Initializes the contract by setting a `name` and a `symbol` to the token collection. */
    constructor (string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
        contractOwner = payable(msg.sender);
        contractMinter = payable(msg.sender);
        _tokenIdTracker.increment(); // we start at 1 
    }
    /* @dev See {IERC721Metadata-name}. */
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    /* @dev See {IERC721Metadata-symbol}. */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    /* @dev returns totalSupply of NFT tokens */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }
    /* @dev Sets new owner and receiver of funds got from creating new tokens */
    function setOwner(address newOwner) public {
        require(msg.sender==contractOwner,"Not an owner");
        contractOwner = payable(newOwner);
    }
    function getOwner() public view returns (address) {
        return contractOwner;
    }
    /* @dev who can mint new NFTS */
    function setMinter(address newMinter) public {
        require(msg.sender==contractOwner || msg.sender==newMinter,"!owner !miner");
        contractMinter = payable(newMinter);
    }
    
    function getCreationPrice() view public returns(uint256) {
        return _creationPrice;
    }
    function setCreationPrice(uint256 price) public  {
        require(msg.sender==contractOwner,"Not an owner");
        _creationPrice = price;
    }
    function setMetadata(bytes32 newCollectionMetadataSwarmLocation) public
    {
        require(msg.sender==contractOwner,"Not an owner");
        collectionMetadataLocation = newCollectionMetadataSwarmLocation;
    }
    function getMetadata() public view returns (bytes32)
    {
        return collectionMetadataLocation;
    }
    /* @dev See {IERC165-supportsInterface}. */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId
            || interfaceId == type(IERC721Metadata).interfaceId
            || interfaceId == type(IERC721Enumerable).interfaceId
            || super.supportsInterface(interfaceId);
    }
    /* @dev See {IERC721-balanceOf}. */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    function tokenOfData(bytes32 dataHash) public view virtual returns (uint256) {
        return tokenDataToToken[dataHash];
    }
    function ownerOfTokenOfData(bytes32 dataHash) public view virtual  returns (address) {
        return ownerOf(tokenDataToToken[dataHash]);
    }
    /** 
     * @dev get owner of token at index  
     */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view override returns (uint256) {
      require(_index < balanceOf(_owner));
      return ownedTokens[_owner][_index];
    }
    function allTokensFrom(address _owner) public view returns (uint256[] memory) {
      require(balanceOf(_owner)>0, "owner has no tokens");
      return ownedTokens[_owner];
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
    */
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }    
    /* @dev See {IERC721Metadata-tokenURI}.*/
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encode(_metadataLocation[tokenId], _tokenDataLocation[tokenId], _tokenAmount[tokenId], _tokenCreator[tokenId], _owners[tokenId], _tokenChallenged[tokenId]));
    }
    /* @dev Base URI for computing {tokenURI}. Empty by default, can be overriden in child contracts.*/
    function _baseURI() internal view virtual returns (string memory) {
        return string(abi.encodePacked(collectionMetadataLocation));
    }
    function tokenCreator(uint256 tokenId) public view virtual returns (address) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenCreator[tokenId];
    }
    function tokenAmount(uint256 tokenId) public view virtual returns (uint256) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenAmount[tokenId];
    }
    function tokenChallenged(uint256 tokenId) public view virtual returns (uint256) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenChallenged[tokenId];
    }
    /* @dev See {IERC721-approve}. */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = NFTCollection.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || NFTCollection.isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }
    /* @dev See {IERC721-getApproved}. */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }
    /* @dev See {IERC721-setApprovalForAll}. */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }
    /* @dev See {IERC721-isApprovedForAll}. */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    /* @dev See {IERC721-transferFrom}. */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }
    /* @dev See {IERC721-safeTransferFrom}. */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    /* @dev See {IERC721-safeTransferFrom}.*/
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = NFTCollection.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || NFTCollection.isApprovedForAll(owner, spender));
    }
    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        _beforeTokenTransfer(address(0), to, tokenId);
        addTokenTo(to, tokenId);
        //emit Transfer(address(0), to, tokenId);
    }
    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = NFTCollection.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);
        _balances[owner] -= 1;

        _removeTokenFromOwnerEnumeration(owner, tokenId);

        ownedTokensCount[owner] -= 1;
        _tokenDataLocation[tokenId] = 0;
        _metadataLocation[tokenId] = 0;
        _tokenCreator[tokenId] = address(0);
        _tokenAmount[tokenId] = 0;   
        
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
    /**
      * @dev Internal function to add a token ID to the list of a given address
      * @param _to address representing the new owner of the given token ID
      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
      */
    function addToken(address _to, uint256 _tokenId) internal {
       require(_owners[_tokenId] == address(0));
       _balances[_to] += 1;
       _owners[_tokenId] = _to;
       ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
    }    
    /**
       * @dev Internal function to add a token ID to the list of a given address
       * @param _to address representing the new owner of the given token ID
       * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
    */
    function addTokenTo(address _to, uint256 _tokenId) internal {
        addToken(_to, _tokenId);
        
        uint256 length = ownedTokens[_to].length;
        ownedTokens[_to].push(_tokenId);
        ownedTokensIndex[_tokenId] = length;
    }
    /**
     * @dev Internal function to remove a token ID from the list of a given address
     * @param _from address representing the previous owner of the given token ID
     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function removeToken(address _from, uint256 _tokenId) internal {
      require(ownerOf(_tokenId) == _from);
      _balances[_from] -= 1;
      ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
      _owners[_tokenId] = address(0);
    }
    /**
     * @dev Internal function to remove a token ID from the list of a given address
     * @param _from address representing the previous owner of the given token ID
     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
    */
    function removeTokenFrom(address _from, uint256 _tokenId) internal {
         removeToken(_from, _tokenId);
    
         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
         // then delete the last slot.
         uint256 tokenIndex = ownedTokensIndex[_tokenId];
         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
    
         ownedTokens[_from][tokenIndex] = lastToken;
         // This also deletes the contents at the last position of the array
         ownedTokens[_from].pop(); //length--;
    
         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
         // the lastToken to the first position, and then dropping the element placed in the last position of the list
    
         ownedTokensIndex[_tokenId] = 0;
         ownedTokensIndex[lastToken] = tokenIndex;
    }
    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(NFTCollection.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        //_balances[from] -= 1;
        //_balances[to] += 1;
        //_owners[tokenId] = to;
        removeTokenFrom(from, tokenId);
        addTokenTo(to, tokenId);        

        emit Transfer(from, to, tokenId);
    }
    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(NFTCollection.ownerOf(tokenId), to, tokenId);
    }
    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal  {

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }
    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        ownedTokensIndex[tokenId] = length;
    }
    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }
    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).
        uint256 lastTokenIndex = balanceOf(from) - 1;
        uint256 tokenIndex = ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }
    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete allTokensIndex[tokenId];
        _allTokens.pop();
    }
     /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     * See {ERC721-_mint}.
     *
     * Requirements:
     *
     * - the caller must be contractOwner
     */
    function mint(address to) public virtual {
        require(msg.sender==contractOwner, "Only owner can mint");
        bytes32  firstLocation = 0x6c00000000000000000000000000000000000000000000000000000000000001;
        bytes32 secondLocation = 0x6c00000000000000000000000000000000000000000000000000000000000002;
        creteNewRefLocation(msg.sender, 2, to, firstLocation, secondLocation);
    }
    /**
     * @dev if funds received return back to sender  
    */
    receive () external payable  {  
       // return funds back to sender 
       payable(msg.sender).transfer(msg.value); 
    }
    /**
     * @dev creates a new NFT with data from swarmLocation
    */
    /*function mintNew(address to, bytes32 metadataSwarmLocation, bytes32 tokenDataSwarmLocation) public payable virtual {
        require(msg.value==_creationPrice,"Cost of creation is wrong");
        require(tokenDataToToken[tokenDataSwarmLocation]==0, "Claimed "); // should be never claimed before

        contractOwner.transfer(msg.value); 
        creteNewRefLocation(to, metadataSwarmLocation, tokenDataSwarmLocation);
    } */
    /**
     * @dev creates a new NFT with data from swarmLocation
    */
    function creteNewRefLocation(address creator, uint256 amount, address to, bytes32 metadataSwarmLocation, bytes32 tokenDataSwarmLocation) internal {
        require(tokenDataToToken[tokenDataSwarmLocation]==0, "Claimed "); // should be never claimed before 
        // uint256 tokenId = uint256(keccak256(abi.encodePacked(msg.sender))); // maybe we want different Id
        uint256 tokenId = _tokenIdTracker.current(); 
        _mint(to, tokenId);
        _tokenIdTracker.increment();
        
        _tokenDataLocation[tokenId] = tokenDataSwarmLocation;
        _metadataLocation[tokenId]  = metadataSwarmLocation;
        _tokenCreator[tokenId]  = creator; 
        _tokenAmount[tokenId]  = amount;
        _tokenChallenged[tokenId] = 0;
    
        tokenDataToToken[tokenDataSwarmLocation] = tokenId; // so same location can't be minted twice 
    }
    /**
     * @dev LiveMining contract can call and create new NFTs
    */
    function mintForUser(address creator, uint256 rank, address to, bytes32 metadataSwarmLocation, bytes32 tokenDataSwarmLocation) public
    {
        require(msg.sender==contractOwner || msg.sender==contractMinter, "!owner !minter");
        creteNewRefLocation(creator, rank, to, metadataSwarmLocation, tokenDataSwarmLocation);
    }
    function challengedFor(uint256 tokenId, uint256 amount) public
    {
        require(msg.sender==contractMinter, "!minter");
        require(_tokenAmount[tokenId]>=amount, "<amount on token"); 
        _tokenChallenged[tokenId] += amount;
    }
    function unslashToken(uint256 tokenId) public
    {
        require(msg.sender==contractMinter, "!minter");
        _tokenChallenged[tokenId] = 0;
    }
    function slashToken(uint256 tokenId) public
    {
        require(msg.sender==contractMinter, "!minter");
        _tokenAmount[tokenId]  -= _tokenChallenged[tokenId];
        _tokenChallenged[tokenId] = 0;
    }
    // call constructor
    
    /*function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    } */
}
/* DataMarket Is a ERC20 token with locked ETH with built-in swap functionality
   is linked to NFT ERC721Enumerable where account can spawn net NFT token with staked value of linked data. 
   Done:
   - handle any token sent to this contract 
 
   
   Missing: 
   - Rate of Decay 
   - generating new ERC721Enumerable collection 
   - many collections
*/

contract DataMarket is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;
    address payable contractOwner;
    address payable contractTresury;
    
    uint256 private constant FEE = 50; // 0.05%
    uint256 private constant FEE_PRECISION = 1e5;
    
    struct Challenge
    {
        bytes32 hash; 
        address issuer; 
        address receiver; 
        uint256 points;
    }
    
    uint256 internal                         _contractETHBalance;
    mapping(address => uint256) internal     _approvedValidators;
    mapping(address => uint256) internal     _balances;
    mapping(address => uint256) internal     _imbalances;
    mapping(address => address) internal     _validatorsAddedBy; 
    address[]   private allValidators;
    
    mapping(bytes32 => uint256) internal     challenges;
    Challenge[] private allChallenges;

    /* ERC20 */    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address payable private _nftAddress;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (uint256 => bool) private _minted;                                  // Mapping did tokenId already mint
    
    event Bought(uint256 amount);
    event Sold(uint256 amount);

    /* create an ERC20 linked to ERC721 that can create new NFTs and mint them, those NFTS can mint ERC29 for value they have been created for */
    constructor (string memory name_, string memory symbol_, address payable nftAddress_) payable {
        _name = name_;
        _symbol = symbol_;
        _nftAddress = nftAddress_;
        
        contractOwner = payable(msg.sender);
        contractTresury = payable(msg.sender);
        addValidator(msg.sender, 1, address(0)); 
        //_mint(msg.sender, 1 gwei);
    }
    /* Create New Collection */
    /*function createNewCollection(string memory collectionName, string memory collectionSymbol) public returns (Collection)
    {
        Collection c = new Collection(collectionName, collectionSymbol); 
        return c;
    }*/
    /* get ERC20 name */
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    /* get ERC20 symbol */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    /* get ERC20 decimals */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }    
    /* See {IERC20-totalSupply}. */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    /* get balance for account */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    /* how imbalance of much user has dusted*/
    function imbalanceOf(address account) public view virtual returns (uint256) {
        return _imbalances[account];
    }
    
    /* Owner can mint one token at the time*/
    function mintOne(uint256 tokenId) public {
        require(_minted[tokenId]==false,"Already minted"); 
        NFTCollection NFT = NFTCollection(_nftAddress); 
        require(NFT.tokenChallenged(tokenId)==0,"challenged"); 
        address tokenOwner = NFT.ownerOf(tokenId);
        require(tokenOwner==msg.sender,"!owner"); 
        uint256 amount = NFT.tokenAmount(tokenId);  
        _minted[tokenId] = true;
        _mint(tokenOwner, amount);
        _imbalances[NFT.tokenCreator(tokenId)] -= amount; // reduce imbalance, dusting balance can occur if tokenId was challanged and slashed
    } 
    /* Owner mints all available tokens */
    function mintAll() public {
        NFTCollection NFT = NFTCollection(_nftAddress); 
        uint256 amount = 0; 
        if(NFT.balanceOf(msg.sender)>0)
        {
          uint256[] memory tokens = NFT.allTokensFrom(msg.sender);
          for(uint256 i=0;i<tokens.length;i++)
          {
              uint256 tokenId = tokens[i]; 
              if(_minted[tokenId]==false && NFT.tokenChallenged(tokenId)==0)
              {
                uint256 tokenValue = NFT.tokenAmount(tokenId);  
                _minted[tokenId] = true;
                _imbalances[NFT.tokenCreator(tokenId)] -= (tokenValue); // dusting balance 
                amount += tokenValue;
              }
          }
          _mint(msg.sender, amount);
        }        
    }
    /* @dev amount available to mint */
    function availableToMint(address account) public view returns (uint256) {
        NFTCollection NFT = NFTCollection(_nftAddress); 
        uint256 amount = 0; 
        if(NFT.balanceOf(account)>0)
        {
          uint256[] memory tokens = NFT.allTokensFrom(account);
          for(uint256 i=0;i<tokens.length;i++)
          {
              uint256 tokenId = tokens[i]; 
              if(_minted[tokenId]==false && NFT.tokenChallenged(tokenId)==0)
                  amount += NFT.tokenAmount(tokenId);
          }
        }
        return amount;
    }
    /* see if token with this id was minted what is balance  Returns true or false and NFT token value */ 
    function tokenMinted(uint256 tokenId) public view returns (bool) {
        return (_minted[tokenId]); 
    }
    /* see if token with this id was minted what is balance Returns true or false and NFT token value */ 
    /*function tokenChallenged(uint256 tokenId) public view returns (uint256) {
        Collection NFT = Collection(_nftAddress); 
        return NFT.tokenChallenged(tokenId);  
    }*/
    /* @dev returns balance of se */
    /*function balanceOfNFT(address from) public view returns (uint256) {
        Collection NFT = Collection(_nftAddress); 
        return NFT.balanceOf(from);
    }*/
    /* @dev amount available to mint */
    /*function tokenIds(address from) public view returns (uint256[] memory) {
        Collection NFT = Collection(_nftAddress); 
        return NFT.allTokensFrom(from);
    }*/
    /* @dev transfer tokens */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    /* @dev set allowance */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    /* @dev approve spender */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    /* @dev transfer from */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }
    /* @dev increase Allowance */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }
    /* @dev decrease Allowance */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }
    /* @dev transfer */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        NFTCollection NFT = NFTCollection(_nftAddress); 
        require(NFT.balanceOf(sender)>0, "ERC20: no transfer without nft"); // if sender has NFT

        //_beforeTokenTransfer(sender, recipient, amount); 

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }
    /* @dev mint token */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        //_beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    /* @dev burn amount of tokens */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        //_beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
    /* @dev approve spender for amount */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    /*function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { 
        
    }*/
    /* Address of NFT contract*/
    function nftAddress() public view returns (address) {
        return _nftAddress;
    }
    /* return ETH balance of this contract */ 
    function balance() public view  returns (uint256) {
        return _contractETHBalance; //address(this).balance;
    }
    /* return price of one token */
    function priceOfOne() public view returns (uint256) {
        require(balance()!=0 && totalSupply()!=0,"no value in market"); 
        return balance() / totalSupply(); // invalid if totalSupply == 0
    }
    /* Get fee */
    function getFee(uint256 tokenAmount) public pure returns (uint256) {
        uint256 fee = tokenAmount.mul(FEE) / FEE_PRECISION;
        return fee;
    }
    /* Get price for tokenAmount */
    function sellPrice(uint256 tokenAmount) public view returns (uint256) {
        return ((tokenAmount-getFee(tokenAmount)) * priceOfOne());
    }
    /* Get price for tokenAmount */
    function buyPrice(uint256 amount) public view returns (uint256) {
        return ((amount-getFee(amount)) / priceOfOne());
    }
    receive () external payable  {  
        buy();
    }
    function buy() public payable {
       require(msg.value>0,"!value"); 
       uint256 fee = getFee(msg.value);
       uint256 amount = msg.value-fee;
       
       //payable(contractOwner).transfer(amount); // not a fair market
       payable(contractTresury).transfer(fee);    // fees go to treasury
       _contractETHBalance += amount;
       _mint(msg.sender, amount);
       emit Bought(amount);
    }
    function sell(uint256 tokenAmount) public payable {
        require(_balances[msg.sender]>=tokenAmount,"No balance");
        uint256 amountSold = sellPrice(tokenAmount);
        payable(msg.sender).transfer(amountSold); // send to seller
        _contractETHBalance -= amountSold;
        _burn(msg.sender, tokenAmount); // first send, then burn 
        emit Sold(tokenAmount);
    }
    /* in case someone sent tokens to this contract they can be salvaged by treasury or owner*/
    function missedTokenSalvage(address to, address _token, uint256 _amount) public {
        require(_token != address(this), "you can't transfer market tokens"); // this is meant only for misplaced tokens that were sent to this contract address 
        require(msg.sender==contractOwner || msg.sender==contractTresury, "!owner !treasury");
        IERC20(_token).approve(address(this), _amount);
        IERC20(_token).transferFrom(address(this), to, _amount); // this could also go to some DEX and be exchanged for whatever
    }
    /* Get balance of token dataMarket contract has */
    function missedTokenGetBalanceOf(address _address) public view returns (uint256) {
        return IERC20(_address).balanceOf(address(this));
    }
    /* set treasury receiver */
    function setTreasury(address newTreasury) public  {
        require(msg.sender==contractOwner || msg.sender==contractTresury, "!owner !treasury");
        contractTresury = payable(newTreasury);
    }
    /* get treasury receiver */
    function getTreasury() public view returns (address) {
        return contractTresury;
    }
    /* Existing validators can add validators, only first level validators can add validators*/
    function addValidator(address validator) public
    {
        uint256 rank = getRank(msg.sender);
        require(_approvedValidators[validator]==0,"Already added");
        addValidator(validator, rank+1, msg.sender); 
    }
    /* Add validator with rank and by which validator it was added */
    function addValidator(address validator, uint256 validatorType, address validatorAddedBy) internal
    {
        _approvedValidators[validator] = validatorType;
        _validatorsAddedBy[validator] = validatorAddedBy;
        allValidators.push(validator);
    }
    /* get all validators */
    function getValidators() public view returns (address[] memory) 
    {
        return allValidators;
    }
    /* returns if forAddress is a validator and what type it is 0 - normal user, 1 - first validator, 2,3,4 ... - validator*/
    function getRank(address forAddress) public view returns (uint256)
    {
        return _approvedValidators[forAddress];
    }
    /* Create a token with token amount at metadatalocation and data location on swarm*/
    function createDataToken(address to, uint256 forTokenAmount, bytes32 metadataSwarmLocation, bytes32 tokenDataSwarmLocation) public {
         //_burn(msg.sender, forTokenAmount); 
         require(_balances[msg.sender] >= forTokenAmount, "ERC20: amount exceeds balance");
         _balances[msg.sender] -= (forTokenAmount);
         _imbalances[msg.sender] += (forTokenAmount); 
         NFTCollection NFT = NFTCollection(_nftAddress); 
         NFT.mintForUser(msg.sender, forTokenAmount, to, metadataSwarmLocation, tokenDataSwarmLocation);
    }
    /* Issue a challenge for amount and datahash*/
    function issueChallenge(address receiver, uint256 forAmount, bytes32 challengeHash) public 
    {
        require(receiver != address(0), "!receiver");
        require(challenges[challengeHash]==0,"challenge exists");
        require(_balances[msg.sender]>=forAmount,"!balance");
        
        NFTCollection NFT = NFTCollection(_nftAddress); 
        address owner = NFT.ownerOfTokenOfData(challengeHash); //
        require(receiver==owner,"token owner !receiver");
        uint256 tokenId = NFT.tokenOfData(challengeHash);
        uint256 tokenAmount = NFT.tokenAmount(tokenId);
        require(tokenAmount>=forAmount,"token owner !receiver");
        require(NFT.tokenChallenged(tokenId)==0,"already challenged");
        
        Challenge memory c = Challenge({hash:challengeHash, issuer:msg.sender, receiver: receiver, points: forAmount }); //, createdAt: block.timestamp});
        
        NFT.challengedFor(tokenId, c.points);
        
        _balances[msg.sender] -= forAmount;
        _imbalances[msg.sender] += forAmount;

        allChallenges.push(c);
        challenges[challengeHash] = allChallenges.length; // 1, never 0
    }
    /* resolve challenge */
    function resolveChallenge(bytes32 challengeHash, bool isRejected) public 
    {
        require(challenges[challengeHash]!=0,"!challenge");
        require(_approvedValidators[msg.sender]>0,"Not a validator"); // cant approve challenge if not validator
        
        uint256 challengeIndex = challenges[challengeHash]-1;
        Challenge memory c = allChallenges[challengeIndex]; 
        require(_approvedValidators[msg.sender]<_approvedValidators[c.issuer] ,"Not a validator"); // has to be higher rank than issuer so 1 beats 2 and 2 beats 3 and so on, 0 validator is not validator
        
        NFTCollection NFT = NFTCollection(_nftAddress); 
        uint256 tokenId = NFT.tokenOfData(challengeHash);
        require(NFT.tokenChallenged(tokenId)!=0,"already challenged");

        _imbalances[c.issuer] -= c.points;
        
        if(isRejected) // return funds to issuer 
        {
            uint256 fee = getFee(c.points); 
            _balances[c.issuer] += (c.points-fee);
            _balances[msg.sender] += fee;            
            NFT.slashToken(tokenId); // token amount is slashed for challengedAmount
        } 
        else // not rejected
        {
            uint256 fee = getFee(c.points); 
            _balances[c.receiver] += (c.points-fee);
            _balances[msg.sender] += fee;
            NFT.unslashToken(tokenId); // token is unslashed
        }

        removeChallenge(challengeIndex);
    }
    /* remove challenge */
    function removeChallenge(uint256 challengeIndex) internal 
    {
        uint256 lastIndex = allChallenges.length - 1;
        Challenge memory lastChallenge = allChallenges[lastIndex];
        allChallenges[lastIndex] = allChallenges[challengeIndex]; // swap last challenge to be deleted position
        challenges[lastChallenge.hash] = challengeIndex;          // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete allChallenges[challengeIndex];
        allChallenges.pop();         
    }
    /* challenge for if it exists */
    function getChallengeFor(bytes32 challengeHash) public view returns (Challenge memory) 
    {
        return allChallenges[challenges[challengeHash]-1];
    }
    /* num challenges */
    function getChallengeNum() public view returns (uint256) 
    {
        return allChallenges.length;
    }
    /* challenge by index */
    function getChallengeIdx(uint256 index) public view returns (Challenge memory) 
    {
        return allChallenges[index];
    } 
}

