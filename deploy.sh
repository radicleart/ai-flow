#!/bin/bash -e
#
############################################################

export DEPLOYMENT=$1
export PORT=22
export SERVER=spinoza.brightblock.org
export DOCKER_NAME=aiflow_api_production
export TARGET_ENV=linode-production
if [ "$DEPLOYMENT" == "devnet" ]; then
  SERVER=leibniz.brightblock.org
  DOCKER_NAME=aiflow_api_staging
  TARGET_ENV=linode-staging
fi
export DOCKER_ID_USER='mijoco'
export DOCKER_CMD='docker'

printf "\n==================================="
printf "\nBuilding image: mijoco/aiflow_api."
printf "\nConnecting to: $SERVER on ssh port $PORT"
printf "\nDeploying container: $DOCKER_NAME."
printf "\nDeploying target: $TARGET_ENV."
printf "\n\n"

$DOCKER_CMD build -t mijoco/aiflow_api .
$DOCKER_CMD tag mijoco/aiflow_api mijoco/aiflow_api
$DOCKER_CMD push mijoco/aiflow_api:latest

  ssh -i ~/.ssh/id_rsa -p $PORT bob@$SERVER "
    cd /home/bob/hubgit/aiflow-api
    pwd
    cat .env;
    docker login;
    docker pull mijoco/aiflow_api;

    docker rm -f ${DOCKER_NAME}
    source /home/bob/.profile;
    docker run -d -t -i --name ${DOCKER_NAME} -p 6060:6060 -e TARGET_ENV='linode-production'  mijoco/aiflow_api
  ";

printf "Finished....\n"
printf "\n-----------------------------------------------------------------------------------------------------\n";

exit 0;

#-e btcRpcUser=${AIFLOW_BTC_RPC_USER} -e btcRpcPwd=${AIFLOW_BTC_RPC_PWD} -e btcNode=${AIFLOW_BTC_NODE} -e mongoDbUrl=${AIFLOW_MONGO_URL} -e mongoDbName=${AIFLOW_MONGO_DBNAME} -e mongoUser=${AIFLOW_MONGO_USER} -e mongoPwd=${AIFLOW_MONGO_PWD} -e sbtcContractId=${AIFLOW_SBTC_CONTRACT_ID} -e poxContractId=${POX_CONTRACT_ID} -e stacksApi=${AIFLOW_STACKS_API} -e bitcoinExplorerUrl=${AIFLOW_BITCOIN_EXPLORER_URL} -e mempoolUrl=${AIFLOW_MEMPOOL_URL} -e blockCypherUrl=${AIFLOW_BLOCK_CYPHER_URL} -e publicAppName=${AIFLOW_PUBLIC_APP} -e publicAppVersion=${AIFLOW_PUBLIC_APP_VERSION} -e host=${AIFLOW_HOST} -e port=${AIFLOW_PORT} -e walletPath=${AIFLOW_WALLET_PATH}