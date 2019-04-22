const request = require('request');

var Service, Characteristic;

const baseUrl = "http://localhost:1234";

module.exports = function(homebridge) {
    Service = homebridge.hap.Service;
    Characteristic = homebridge.hap.Characteristic;
    homebridge.registerAccessory("homebridge-macbulb", "MacBulb", MacBulb);
};

function MacBulb(log, config) {
	this.log = log;
	this.name = config.name;
}

MacBulb.prototype = {
	getServices() {	
		const bulbService = new Service.Lightbulb(this.name);

		bulbService
			.getCharacteristic(Characteristic.On)
			.on('get', this.getOn.bind(this))
			.on('set', this.setOn.bind(this));

		bulbService
			.getCharacteristic(Characteristic.Hue)
			.on('get', this.getHue)
			.on('set', this.setHue.bind(this));

		bulbService
			.getCharacteristic(Characteristic.Saturation)
			.on('get', this.getSaturation)
			.on('set', this.setSaturation.bind(this));

		bulbService
			.getCharacteristic(Characteristic.Brightness)
			.on('get', this.getBrightness)
			.on('set', this.setBrightness.bind(this));

		return [bulbService];
	},

	getOn(callback) {
		const self = this;
		request
			.get(baseUrl + "/power")
			.on('data', function(data) {
				json = JSON.parse(data)
				callback(null, json["on"])
			})
			.on('error', callback);
	},

	setOn(isOn, callback) {
		request
			.put(baseUrl + "/power")
			.form({on: isOn ? "true" : "false"})
			.on('response', function(response) {
				callback(null);
			})
			.on('error', callback);
	},

	getHue(callback) {
		request
			.get(baseUrl + "/hue")
			.on('data', function(data) {
				json = JSON.parse(data)
				callback(null, json["value"])
			})
			.on('error', callback);
	},

	getSaturation(callback) {
		request
			.get(baseUrl + "/saturation")
			.on('data', function(data) {
				json = JSON.parse(data)
				callback(null, json["value"])
			})
			.on('error', callback);
	},

	getBrightness(callback) {
		request
			.get(baseUrl + "/brightness")
			.on('data', function(data) {
				json = JSON.parse(data)
				callback(null, json["value"])
			})
			.on('error', callback);
	},

	setHue(level, callback) {
		request
			.put(baseUrl + "/hue")
			.form({value: level})
			.on('response', function(response) {
				callback(null);
			})
			.on('error', callback);
	},

	setSaturation(level, callback) {
		request
			.put(baseUrl + "/saturation")
			.form({value: level})
			.on('response', function(response) {
				callback(null);
			})
			.on('error', callback);
	},

	setBrightness(level, callback) {
		request
			.put(baseUrl + "/brightness")
			.form({value: level})
			.on('response', function(response) {
				callback(null);
			})
			.on('error', callback);
	}
}