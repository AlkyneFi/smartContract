// truffle-config.js
module.exports = {
  networks: {
      klaytn: {
          host: '127.0.0.1',
          port: 8551,
          from: '0x75a59b94889a05c03c66c3c84e9d2f8308ca4abd', // enter your account address
          network_id: '1001', // Baobab network id
          gas: 20000000, // transaction gas limit
          gasPrice: 25000000000, // gasPrice of Baobab is 25 Gpeb
      },
  },
  compilers: {
    solc: {
      version: "0.5.6"    // Specify compiler's version to 0.5.6
    }
}
};