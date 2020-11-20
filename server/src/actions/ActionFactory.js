const Chime = require('./Chime');
const Log = require('./Log');

class ActionFactory {
  static createActionFromConfig(config) {
    switch (config.type) {
      case 'chime':
        return new Chime(config);
      case 'log':
        return new Log(config);
      default:
        throw new Error(`unkown type: ${config.type}`);
    }
  }
}

module.exports = ActionFactory;
