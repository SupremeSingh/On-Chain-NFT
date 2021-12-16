/// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

contract manualNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    mapping (address => uint256) public addressToTokenID;
    mapping (address => uint256) public addressToNumberOwned;

    modifier ownsNone() {
        require(addressToNumberOwned[msg.sender] == 0, "You can only own 1 NFT");
        _;
    }

    event CreatedSVGNFT(uint256 indexed tokenId, string tokenURI);
    event TransferredSVGNFT(uint256 indexed tokenId, address receiver);
    event BurnedSVGNFT(uint256 indexed tokenId);

    constructor() ERC721("SVG NFT", "svgNFT")
    {
        tokenCounter = 0;
    }

    function create(string memory svg) public ownsNone() {
        _safeMint(msg.sender, tokenCounter);

        addressToTokenID[msg.sender] = tokenCounter;
        addressToNumberOwned[msg.sender] += 1;
        
        string memory imageURI = svgToImageURI(svg);
        _setTokenURI(tokenCounter, formatTokenURI(imageURI));
        
        tokenCounter = tokenCounter + 1;
        emit CreatedSVGNFT(tokenCounter, svg);
    }


    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }

    function formatTokenURI(string memory imageURI) public pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "SVG NFT", // You can add whatever name here
                                '", "description":"An NFT based on SVG!", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }

    function approveAndTransfer(address receiver) public {
        uint256 tokenId = addressToTokenID[msg.sender];
        approve(receiver, tokenId);
        
        safeTransferFrom(msg.sender, receiver, tokenId);
        emit TransferredSVGNFT(tokenId,receiver);
    }

    function exists() public view returns (bool) {
        return _exists(addressToTokenID[msg.sender]);
    }

    function burn() public {
        uint256 tokenId = addressToTokenID[msg.sender];
        _burn(tokenId);
        emit BurnedSVGNFT(tokenId);
    }

}