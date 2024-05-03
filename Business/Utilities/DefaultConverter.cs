using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Utilities {
    static class DefaultConverter {
        public static string GetString(byte[] bytes) {
            if (bytes == null || bytes.Length <= 0) {
                throw new ArgumentNullException("bytes");
            }

            return Encoding.Default.GetString(bytes);
        }

        public static byte[] GetBytes(string s) {
            if (string.IsNullOrEmpty(s)) {
                throw new ArgumentNullException("s");
            }

            return Encoding.Default.GetBytes(s);
        }
    }
}
