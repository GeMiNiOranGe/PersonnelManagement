namespace Presentation
{
    partial class FormGrantRole
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dtgvGrant = new System.Windows.Forms.DataGridView();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnForbid = new System.Windows.Forms.PictureBox();
            this.btnPermiss = new System.Windows.Forms.PictureBox();
            this.cbColumnName = new System.Windows.Forms.ComboBox();
            this.tbName = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.cbPermission = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.cbRoleID = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dtgvGrant)).BeginInit();
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnForbid)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPermiss)).BeginInit();
            this.SuspendLayout();
            // 
            // dtgvGrant
            // 
            this.dtgvGrant.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dtgvGrant.Location = new System.Drawing.Point(135, 259);
            this.dtgvGrant.Name = "dtgvGrant";
            this.dtgvGrant.ReadOnly = true;
            this.dtgvGrant.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dtgvGrant.Size = new System.Drawing.Size(562, 204);
            this.dtgvGrant.TabIndex = 0;
            this.dtgvGrant.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dtgvGrant_CellContentClick);
            // 
            // groupBox1
            // 
            this.groupBox1.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.groupBox1.Controls.Add(this.btnForbid);
            this.groupBox1.Controls.Add(this.btnPermiss);
            this.groupBox1.Controls.Add(this.cbColumnName);
            this.groupBox1.Controls.Add(this.tbName);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.cbPermission);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.cbRoleID);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(141, 50);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(550, 203);
            this.groupBox1.TabIndex = 1;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Function";
            // 
            // btnForbid
            // 
            this.btnForbid.BackgroundImage = global::Presentation.Properties.Resources.IconForbid;
            this.btnForbid.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.btnForbid.Location = new System.Drawing.Point(294, 135);
            this.btnForbid.Name = "btnForbid";
            this.btnForbid.Size = new System.Drawing.Size(63, 47);
            this.btnForbid.TabIndex = 14;
            this.btnForbid.TabStop = false;
            // 
            // btnPermiss
            // 
            this.btnPermiss.BackgroundImage = global::Presentation.Properties.Resources.IconPermiss;
            this.btnPermiss.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.btnPermiss.Location = new System.Drawing.Point(170, 135);
            this.btnPermiss.Name = "btnPermiss";
            this.btnPermiss.Size = new System.Drawing.Size(62, 44);
            this.btnPermiss.TabIndex = 13;
            this.btnPermiss.TabStop = false;
            this.btnPermiss.Click += new System.EventHandler(this.btnPermiss_Click);
            // 
            // cbColumnName
            // 
            this.cbColumnName.FormattingEnabled = true;
            this.cbColumnName.Location = new System.Drawing.Point(387, 81);
            this.cbColumnName.Name = "cbColumnName";
            this.cbColumnName.Size = new System.Drawing.Size(143, 21);
            this.cbColumnName.TabIndex = 12;
            this.cbColumnName.SelectedIndexChanged += new System.EventHandler(this.cbColumnName_SelectedIndexChanged);
            // 
            // tbName
            // 
            this.tbName.Location = new System.Drawing.Point(387, 35);
            this.tbName.Name = "tbName";
            this.tbName.Size = new System.Drawing.Size(143, 20);
            this.tbName.TabIndex = 8;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(306, 85);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(73, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "ColumnName:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(341, 39);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(38, 13);
            this.label4.TabIndex = 5;
            this.label4.Text = "Name:";
            // 
            // cbPermission
            // 
            this.cbPermission.FormattingEnabled = true;
            this.cbPermission.Location = new System.Drawing.Point(80, 77);
            this.cbPermission.Name = "cbPermission";
            this.cbPermission.Size = new System.Drawing.Size(121, 21);
            this.cbPermission.TabIndex = 4;
            this.cbPermission.SelectedIndexChanged += new System.EventHandler(this.cbPermission_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 83);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(71, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "PermissionID:";
            // 
            // cbRoleID
            // 
            this.cbRoleID.FormattingEnabled = true;
            this.cbRoleID.Location = new System.Drawing.Point(80, 36);
            this.cbRoleID.Name = "cbRoleID";
            this.cbRoleID.Size = new System.Drawing.Size(121, 21);
            this.cbRoleID.TabIndex = 2;
            this.cbRoleID.SelectedIndexChanged += new System.EventHandler(this.cbRoleID_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(34, 41);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(43, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "RoleID:";
            // 
            // FormGrantRole
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.ClientSize = new System.Drawing.Size(800, 461);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.dtgvGrant);
            this.Name = "FormGrantRole";
            this.Text = "Grant Role";
            this.Load += new System.EventHandler(this.FormGrantRole_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dtgvGrant)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnForbid)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPermiss)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dtgvGrant;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox tbName;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox cbPermission;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox cbRoleID;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cbColumnName;
        private System.Windows.Forms.PictureBox btnForbid;
        private System.Windows.Forms.PictureBox btnPermiss;
    }
}