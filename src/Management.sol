// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Error.sol";

contract Management {
    struct Student {
        string name;
        uint8 age;
        uint8 level;
        bool registered;
    }

    string public schoolName;
    string public poBox;
    string public schoolAddress;
    string public principal;
    address public owner;

    mapping(address => Student) public students;
    mapping(address => mapping(string => uint8)) public scores;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotSchoolOwner();
        }
        _;
    }

    constructor(
        string memory _name,
        string memory _poBox,
        string memory _schoolAddress,
        string memory _principal,
        address _owner
    ) {
        schoolName = _name;
        poBox = _poBox;
        schoolAddress = _schoolAddress;
        principal = _principal;
        owner = _owner;
    }

    function addStudent(
        address _id,
        string memory _name,
        uint8 _age,
        uint8 _level
    ) external onlyOwner {
        if (students[_id].registered) {
            revert StudentAlreadyExists(_id);
        }
        students[_id] = Student(_name, _age, _level, true);
    }

    function promote(address _id) external onlyOwner {
        if (!students[_id].registered) {
            revert StudentNotFound(_id);
        }
        students[_id].level += 1;
    }

    function scoreStudent(
        address _id,
        string memory _subject,
        uint8 _score
    ) external onlyOwner {
        if (!students[_id].registered) {
            revert StudentNotFound(_id);
        }
        if (_score > 100) {
            revert InvalidScore(_score);
        }
        scores[_id][_subject] = _score;
    }

    function getReportCard(
        address _id,
        string memory _subject
    ) external view returns (string memory, uint8, uint8, uint8) {
        if (!students[_id].registered) {
            revert StudentNotFound(_id);
        }
        Student memory s = students[_id];
        return (s.name, s.age, s.level, scores[_id][_subject]);
    }
}
