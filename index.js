const brightness = require('brightness');

var Service, Characteristic;

module.exports = function(homebridge) {
    Service = homebridge.hap.Service;
    Characteristic = homebridge.hap.Characteristic;
    homebridge.registerAccessory("homebridge-plugin-macbulb", "MacBulb", MacBulb);
};

function MacBulb(log, config) {
	this.log = log;
	this.name = config.name;
	this.lastBrightnessLevel = 1.0;
	this.isSettingBrightness = false;
}

MacBulb.prototype = {
	getServices() {	
		const bulbService = new Service.Lightbulb(this.name);

		const onCharacteristic = bulbService
			.getCharacteristic(Characteristic.On)
			.on('get', this.getOn.bind(this))
			.on('set', this.setOn.bind(this));

		const brightnessCharacteristic = bulbService
			.getCharacteristic(Characteristic.Brightness)
			.on('get', this.getBrightness)
			.on('set', this.setBrightness.bind(this));

		const self = this;

		setInterval(function() {
			brightness.get().then(level => {
				const brightnessLevel = Math.floor(level * 100);

				if(brightnessLevel > 0) {
					brightnessCharacteristic.updateValue(brightnessLevel);
					self.lastBrightnessLevel = level;
				}

				onCharacteristic.updateValue(brightnessLevel > 0);
			})
		}, 1000);

		return [bulbService];
	},

	getOn(callback) {
		const self = this;

		brightness.get().then(level => {
			const isOn = level > 0
			callback(null, isOn);

			self.lastBrightnessLevel = level;
		});
	},

	setOn(isOn, callback) {
		const self = this;

		if(self.isSettingBrightness) {
			callback(null);

			return;
		}

		brightness.set(isOn ? self.lastBrightnessLevel : 0.0).then(() => {
			callback(null);
		})
	},

	getBrightness(callback) {
		brightness.get().then(level => {
			callback(null, Math.floor(level * 100));
		})
	},

	setBrightness(level, callback) {
		const self = this;

		self.log("Set brightness: ", level);

		self.isSettingBrightness = true;
		brightness.set(level / 100).then(() => {
			callback(null);

			self.lastBrightnessLevel = level / 100;
			self.isSettingBrightness = false;
		})
	}
}