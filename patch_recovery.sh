/bin/cp -f ns_audit_org /usr/local/nswcf/ns_audit/ns_audit
/bin/cp -f ns_audit_ge12g_org /usr/local/nswcf/ns_audit/ns_audit_ge12g
/bin/cp -f ns_audit_lt12g_org /usr/local/nswcf/ns_audit/ns_audit_lt12g
chmod 755 /usr/local/nswcf/ns_audit/ns_audit
/usr/local/nswcf/ns_audit/ns_audit_ctl restart
