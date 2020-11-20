const util = require('util');
const path = require('path');
const exec = util.promisify(require('child_process').exec);
const BaseAction = require('./BaseAction');

const chimeCount = 0;
const moduleId = null;

class ChimeAction extends BaseAction {
  constructor(options) {
    super();
    this.muteAll = options.mute;
    this.chime = options.sound;
  }

  async muteOtherSystemSounds() {
    if (!this.muteAll || chimeCount > 0) {
      return null;
    }
    return exec(path.resolve(__filename, '../../../', './scripts/mute-all.sh'));
  }

  unmuteOtherSystemSounds() {
    if (!this.muteAll) {
      return null;
    }
    const scriptPath = path.resolve(__filename, '../../../', './scripts/unmute-all.sh');
    return exec(`${scriptPath} ${moduleId}`);
  }

  playChime() {
    const scriptFile = path.resolve(__filename, '../../../', `./scripts/chime.sh`);
    return exec(`${scriptFile} ${this.chime}`);
  }

  async execute() {
    await this.muteOtherSystemSounds();
    await this.playChime();
    await this.unmuteOtherSystemSounds();
  }
}

module.exports = ChimeAction;
