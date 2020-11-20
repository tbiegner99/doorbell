const Getopt = require('node-getopt');
const ActionsFactory = require('./actions/ActionFactory');
const Doorbell = require('./Doorbell');

const getopt = new Getopt([
  ['c', 'config=', 'location of the configuration file'],
  ['h', 'help'],
]).bindHelp();

const { options } = getopt.parse(process.argv.slice(2));

if (!options.config) {
  console.error('Config file is required. Pass --config');
  process.exit(1);
}
const config = require(options.config); // eslint-disable-line import/no-dynamic-require

const appConfig = {
  gpioPin: config.gpioPin,
  actions: config.actions.map(ActionsFactory.createActionFromConfig),
};

new Doorbell(appConfig).start();
