module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();

  // the following will only deploy "GenericMetaTxProcessor" if the contract was never deployed or if the code changed since last deployment
  const res = await deploy('CLPositionDescriptorOffChain', {
    from: deployer,
    gasLimit: 400000000,
    args: ["sun.io/v4/"],
    tags: 'lumi',
  });
  console.log(res)
};


module.exports.tags = ['lumi'];
