using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Business.Security {
    static class SaltGenerator {
        public static byte[] GenerateSalt(int saltSize) {
            using (var generator = RandomNumberGenerator.Create()) {
                var salt = new byte[saltSize];
                generator.GetBytes(salt);
                return salt;
            }
        }
    }
}
