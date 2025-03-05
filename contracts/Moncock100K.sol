// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Moncock100K is ERC721A, Ownable {

    // config
    constructor(address initialOwner) ERC721A("Moncock 100K", "MONCOCK100K") Ownable(initialOwner) {}
    uint256 public MAX_MINT_PER_WALLET = 1;
    uint256 public START_ID = 1;

    bool public mintEnabled = true;
    string public baseURI = "https://moncock.github.io/launchpad/images/100k.png";

    // start token id
    function _startTokenId() internal view virtual override returns (uint256) {
        return START_ID;
    }

    // metadata
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string.concat(
            "data:application/json;utf8,",
            '{"name": "Moncock 100K #', Strings.toString(tokenId),
            '","description":"Let\'s celebrate the minting of 100,000 Moncock OG NFTs on Monad Testnet ', unicode"🎉",
            '","image":"', baseURI, '"}'
        );
    }

    // toggle sale
    function toggleSale() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    // mint
    function mint(uint quantity, bytes32[] calldata _merkleProof) external {
        require(mintEnabled, "Sale is not enabled");
        require(_numberMinted(msg.sender) + quantity <= MAX_MINT_PER_WALLET, "Over wallet limit");
        
        _mint(msg.sender, quantity);
    }
    function adminMint(uint quantity) external onlyOwner {
        _mint(msg.sender, quantity);
    }

    // aliases
    function numberMinted(address owner) external view returns (uint256) {
        return _numberMinted(owner);
    }
    function remainingSupply() external pure returns (uint256) {
        return 0;
    }

}
