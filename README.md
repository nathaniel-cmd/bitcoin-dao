# Decentralized Autonomous Organization (DAO) Smart Contract

A comprehensive Clarity smart contract implementing a full-featured DAO with membership management, proposal system, treasury management, and cross-DAO collaboration capabilities.

## Features

### Membership Management

- Join/leave DAO functionality
- Reputation-based system
- Token staking mechanism
- Activity tracking
- Automatic reputation decay for inactive members

### Proposal System

- Create and vote on proposals
- Quadratic voting (weighted by reputation and stake)
- Automatic proposal expiration (1440 blocks ≈ 10 days)
- Multiple proposal states: active, executed, rejected

### Treasury Management

- STX token handling
- Secure fund management
- Donation system
- Balance tracking
- Protected withdrawal through proposals

### Cross-DAO Collaboration

- Propose collaborations with other DAOs
- Accept/reject collaboration requests
- Track collaboration status
- Inter-DAO proposal linking

## Contract Functions

### Membership Functions

```clarity
(define-public (join-dao))
(define-public (leave-dao))
(define-public (stake-tokens (amount uint)))
(define-public (unstake-tokens (amount uint)))
```

### Proposal Functions

```clarity
(define-public (create-proposal (title (string-ascii 50))
                              (description (string-utf8 500))
                              (amount uint)))
(define-public (vote-on-proposal (proposal-id uint) (vote bool)))
(define-public (execute-proposal (proposal-id uint)))
```

### Treasury Functions

```clarity
(define-public (donate-to-treasury (amount uint)))
(define-read-only (get-treasury-balance))
```

### Collaboration Functions

```clarity
(define-public (propose-collaboration (partner-dao principal) (proposal-id uint)))
(define-public (accept-collaboration (collaboration-id uint)))
```

### Read-Only Functions

```clarity
(define-read-only (get-proposal (proposal-id uint)))
(define-read-only (get-member (user principal)))
(define-read-only (get-total-members))
(define-read-only (get-total-proposals))
(define-read-only (get-member-reputation (user principal)))
```

## Data Structures

### Member Data

```clarity
{
  reputation: uint,
  stake: uint,
  last-interaction: uint
}
```

### Proposal Data

```clarity
{
  creator: principal,
  title: (string-ascii 50),
  description: (string-utf8 500),
  amount: uint,
  yes-votes: uint,
  no-votes: uint,
  status: (string-ascii 10),
  created-at: uint,
  expires-at: uint
}
```

### Collaboration Data

```clarity
{
  partner-dao: principal,
  proposal-id: uint,
  status: (string-ascii 10)
}
```

## Security Features

1. Access Control

   - Contract owner privileges
   - Member-only functions
   - Proper authorization checks

2. Fund Safety

   - Protected treasury management
   - Secure token transfers
   - Proposal-based withdrawals

3. Data Validation
   - Input validation
   - State checks
   - Error handling

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access attempt
- `ERR-ALREADY-MEMBER (u101)`: Duplicate membership attempt
- `ERR-NOT-MEMBER (u102)`: Non-member action attempt
- `ERR-INVALID-PROPOSAL (u103)`: Invalid proposal operation
- `ERR-PROPOSAL-EXPIRED (u104)`: Expired proposal interaction
- `ERR-ALREADY-VOTED (u105)`: Duplicate vote attempt
- `ERR-INSUFFICIENT-FUNDS (u106)`: Insufficient balance
- `ERR-INVALID-AMOUNT (u107)`: Invalid amount specified

## Governance Parameters

- Initial reputation: 1
- Reputation multiplier for voting power: 10x
- Proposal duration: 1440 blocks (≈10 days)
- Inactivity threshold: 4320 blocks (≈30 days)
- Reputation decay: 50% after inactivity period

## Usage Examples

### Joining the DAO

```clarity
(contract-call? .dao join-dao)
```

### Creating a Proposal

```clarity
(contract-call? .dao create-proposal "New Initiative"
               "Description of the initiative" u1000)
```

### Voting on a Proposal

```clarity
(contract-call? .dao vote-on-proposal u1 true)
```

### Staking Tokens

```clarity
(contract-call? .dao stake-tokens u500)
```

## Best Practices

1. Always check function return values
2. Handle errors appropriately
3. Verify proposal status before voting
4. Ensure sufficient funds before transactions
5. Monitor reputation decay periods

## Testing

Comprehensive testing should cover:

1. Membership operations
2. Proposal lifecycle
3. Voting mechanisms
4. Treasury operations
5. Collaboration features
6. Error conditions
7. Edge cases

## License

This smart contract is open source and available under the MIT License.
