;; Title:  Bitcoin Decentralized Autonomous Organization (DAO) Contract
;; Summary: A comprehensive DAO implementation with membership, proposal, treasury, and collaboration features
;; Description: This contract implements core DAO functionality including:
;;  - Membership management with reputation and staking
;;  - Proposal creation and voting system
;;  - Treasury management with STX tokens
;;  - Cross-DAO collaboration capabilities
;;  - Reputation system with decay for inactive members

;; Constants
;; =========

;; Access control and error codes
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-MEMBER (err u101))
(define-constant ERR-NOT-MEMBER (err u102))
(define-constant ERR-INVALID-PROPOSAL (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-ALREADY-VOTED (err u105))
(define-constant ERR-INSUFFICIENT-FUNDS (err u106))
(define-constant ERR-INVALID-AMOUNT (err u107))

;; State Variables
;; ==============

(define-data-var total-members uint u0)
(define-data-var total-proposals uint u0)
(define-data-var treasury-balance uint u0)

;; Data Maps
;; =========

;; Member data including reputation, stake, and activity tracking
(define-map members principal 
  {
    reputation: uint,
    stake: uint,
    last-interaction: uint
  }
)

;; Proposal data with voting and status tracking
(define-map proposals uint 
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
)

;; Vote tracking per proposal and voter
(define-map votes {proposal-id: uint, voter: principal} bool)

;; Cross-DAO collaboration tracking
(define-map collaborations uint 
  {
    partner-dao: principal,
    proposal-id: uint,
    status: (string-ascii 10)
  }
)

;; Private Functions
;; ================

;; Checks if a given principal is a member
(define-private (is-member (user principal))
  (match (map-get? members user)
    member-data true
    false
  )
)

;; Validates if a proposal is active and not expired
(define-private (is-active-proposal (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (and 
      (< block-height (get expires-at proposal))
      (is-eq (get status proposal) "active")
    )
    false
  )
)

;; Validates proposal existence
(define-private (is-valid-proposal-id (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal true
    false
  )
)


;; Validates collaboration existence
(define-private (is-valid-collaboration-id (collaboration-id uint))
  (match (map-get? collaborations collaboration-id)
    collaboration true
    false
  )
)

;; Calculates member voting power based on reputation and stake
(define-private (calculate-voting-power (user principal))
  (let (
    (member-data (unwrap! (map-get? members user) u0))
    (reputation (get reputation member-data))
    (stake (get stake member-data))
  )
    (+ (* reputation u10) stake)
  )
)

;; Updates member reputation with activity tracking
(define-private (update-member-reputation (user principal) (change int))
  (match (map-get? members user)
    member-data 
    (let (
      (new-reputation (to-uint (+ (to-int (get reputation member-data)) change)))
      (updated-data (merge member-data {reputation: new-reputation, last-interaction: block-height}))
    )
      (map-set members user updated-data)
      (ok new-reputation)
    )
    ERR-NOT-MEMBER
  )
)

;; Public Functions
;; ===============

;; Membership Management
;; --------------------

(define-public (join-dao)
  (let (
    (caller tx-sender)
  )
    (asserts! (not (is-member caller)) ERR-ALREADY-MEMBER)
    (map-set members caller {reputation: u1, stake: u0, last-interaction: block-height})
    (var-set total-members (+ (var-get total-members) u1))
    (ok true)
  )
)

(define-public (leave-dao)
  (let (
    (caller tx-sender)
  )
    (asserts! (is-member caller) ERR-NOT-MEMBER)
    (map-delete members caller)
    (var-set total-members (- (var-get total-members) u1))
    (ok true)
  )
)