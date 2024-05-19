using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class RoleBussiness
    {
        private RoleData rolePermissionData;

        public RoleBussiness()

        {
            rolePermissionData = new RoleData();
        }

        public DataTable GetRolePermissions()
        {
            return rolePermissionData.GetRolePermissions();
        }
        public DataTable GetRoles()
        {
            return rolePermissionData.getRoleID();
        }
        public DataTable GetPermission()
        {
            return rolePermissionData.getPermissionsID();
        }
        public bool GrantRole(int roleId, int roleIDAdd, int permissionId, string name, string columnName)
        {
           bool checkGrant= rolePermissionData.GrantRole(roleId, roleIDAdd, permissionId, name, columnName);
           return checkGrant;
        }

    }
}
