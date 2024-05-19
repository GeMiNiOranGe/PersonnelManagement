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
        public void GrantRole(int roleID, int roleIDAdd, int permissionID, string name, string columnName)
        {
            rolePermissionData.GrantRole(roleID, roleIDAdd, permissionID, name, columnName);
        }
        public void UpdateRolePermission(int roleID, int roleIDAdd,int permissionID, string columnName)
        {
            rolePermissionData.UpdateRolePermission(roleID, roleIDAdd,permissionID, columnName);
        }

    }
}
