const BaseAction = require('./BaseAction');

class LogAction extends BaseAction {
  constructor(options) {
    super();
    this.message = options.message;
  }

  async execute() {
    console.log(this.message);
  }
}

module.exports = LogAction;
