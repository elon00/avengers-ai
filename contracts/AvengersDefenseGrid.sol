// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AvengersDefenseGrid
 * @dev Multi-Hero Council Quorum Consensus & Planetary Defense Protocol
 */
contract AvengersDefenseGrid {
    address[4] public council; // Stark, Rogers, Banner, Thor
    uint256 public constant REQUIRED_QUORUM = 3;
    bool public planetaryDefenseActive;

    struct DefenseProposal {
        bytes32 threatId;
        uint256 votes;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(bytes32 => DefenseProposal) public proposals;

    event ThreatDetected(bytes32 indexed threatId, uint256 severity);
    event QuorumReached(bytes32 indexed threatId, uint256 votes);
    event PlanetaryDefenseTriggered(bool active);

    constructor(address _ironMan, address _cap, address _hulk, address _thor) {
        council[0] = _ironMan;
        council[1] = _cap;
        council[2] = _hulk;
        council[3] = _thor;
    }

    function voteDefenseAction(bytes32 threatId) external {
        bool isCouncil = false;
        for (uint i = 0; i < 4; i++) {
            if (council[i] == msg.sender) isCouncil = true;
        }
        require(isCouncil, "Not an Avenger");

        DefenseProposal storage p = proposals[threatId];
        require(!p.voted[msg.sender], "Already voted");

        p.voted[msg.sender] = true;
        p.votes += 1;

        if (p.votes >= REQUIRED_QUORUM && !p.executed) {
            p.executed = true;
            planetaryDefenseActive = true;
            emit QuorumReached(threatId, p.votes);
            emit PlanetaryDefenseTriggered(true);
        }
    }
}
