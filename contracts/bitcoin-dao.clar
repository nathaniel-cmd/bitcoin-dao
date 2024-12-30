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