using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO {
    public enum LoginStatus {
        None,
        Success,
        InvalidInput,
        InvalidAccount,
        LockedAccount,
        OtherError
    }
}
