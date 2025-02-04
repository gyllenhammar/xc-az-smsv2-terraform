#cloud-config
write_files:
  - path: /etc/vpm/user_data
    permissions: 644
    owner: root
    content: |
      token: ${token}
