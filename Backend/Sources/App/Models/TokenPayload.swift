import JWT

struct TokenPayload: JWTPayload {
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}