using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Authentication;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Business {
    static class Hasher {
        public static byte[] CreateHash(string message, HashAlgorithmType type) {
            if (string.IsNullOrEmpty(message)) {
                throw new ArgumentNullException("message");
            }

            using (HashAlgorithm algorithm = GetHashAlgorithm(type)) {
                var inputBytes = Encoding.UTF8.GetBytes(message);
                var hashBytes = algorithm.ComputeHash(inputBytes);
                return hashBytes;
            }
        }

        private static HashAlgorithm GetHashAlgorithm(HashAlgorithmType type) {
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
    }
}
