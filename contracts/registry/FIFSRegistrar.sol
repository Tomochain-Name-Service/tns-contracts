pragma solidity >=0.8.4;

import "./TomoNs.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */
contract FIFSRegistrar {
    TomoNs tomoNs;
    bytes32 rootNode;

    modifier only_owner(bytes32 label) {
        address currentOwner = tomoNs.owner(
            keccak256(abi.encodePacked(rootNode, label))
        );
        require(currentOwner == address(0x0) || currentOwner == msg.sender);
        _;
    }

    /**
     * Constructor.
     * @param tomoNsAddr The address of the TomoNs registry.
     * @param node The node that this registrar administers.
     */
    constructor(TomoNs tomoNsAddr, bytes32 node) public {
        tomoNs = tomoNsAddr;
        rootNode = node;
    }

    /**
     * Register a name, or change the owner of an existing registration.
     * @param label The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 label, address owner) public only_owner(label) {
        tomoNs.setSubnodeOwner(rootNode, label, owner);
    }
}
