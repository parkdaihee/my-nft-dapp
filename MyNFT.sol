// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyOptimizedNFT
 * @dev 
 * 1. onlyOwner 제거로 누구나 민팅 가능
 * 2. ERC721Enumerable 상속으로 전체 NFT 목록 열거 가능
 */
contract MyNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("MyTestNFT", "MTN") Ownable(msg.sender) {}

    /**
     * @notice 누구나 새로운 NFT를 민팅할 수 있습니다.
     * @param to NFT를 받을 주소
     * @param uri 메타데이터 JSON 주소 (IPFS 등)
     */
    function safeMint(address to, string memory uri) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        
        return tokenId;
    }

    // =============================================================
    //                        Overrides
    // =============================================================

    /**
     * @dev ERC721Enumerable과 ERC721URIStorage 사이의 충돌을 해결하기 위한 오버라이드
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev 토큰 전송 시 인덱스를 업데이트하기 위해 _update를 오버라이드 (OZ 5.0 방식)
     */
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    /**
     * @dev 잔액 업데이트 시 Enumerable 로직을 함께 수행하기 위한 오버라이드
     */
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    /**
     * @dev 지원하는 인터페이스 정보를 응답하기 위한 오버라이드
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}