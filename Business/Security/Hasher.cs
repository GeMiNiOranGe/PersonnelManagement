using System;
using System.Linq;
using System.Security.Authentication;
using System.Security.Cryptography;

using Business.Utilities;

namespace Business.Security {
    static class Hasher {
        #region Factory method Design Pattern
        private static HashAlgorithm CreateHashAlgorithm(HashAlgorithmType type) {
            switch (type) {
            case HashAlgorithmType.Md5:
                return MD5.Create();
            case HashAlgorithmType.Sha1:
                return SHA1.Create();
            case HashAlgorithmType.Sha256:
                return SHA256.Create();
            case HashAlgorithmType.Sha384:
                return SHA384.Create();
            case HashAlgorithmType.Sha512:
                return SHA512.Create();
            default:
                throw new ArgumentException("Invalid hash algorithm type.");
            }
        }
        #endregion

        public static byte[] ComputeHash(string message, HashAlgorithmType type) {
            if (string.IsNullOrEmpty(message)) {
                throw new ArgumentNullException("message");
            }

            byte[] castMessage = DefaultConverter.GetBytes(message);
            using (HashAlgorithm algorithm = CreateHashAlgorithm(type)) {
                byte[] hashedMessage = algorithm.ComputeHash(castMessage);
                return hashedMessage;
            }
        }

        public static bool VerifyMessage(string rawMessage, byte[] hashedMessage, HashAlgorithmType hashAlgorithmType) {
            byte[] hashedRawMessage = ComputeHash(rawMessage, hashAlgorithmType);
            return hashedRawMessage.SequenceEqual(hashedMessage);
        }
    }
}
