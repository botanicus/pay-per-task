#!/usr/bin/env protractor

/* See https://github.com/angular/protractor/blob/master/referenceConf.js */
exports.config = {
  seleniumAddress: 'http://localhost:4444/wd/hub',
  baseUrl: 'http://pay-per-task.dev',
  specs: ['tests/features/*.js'],
  capabilities: {
    browserName: process.env.BROWSER || 'phantomjs'
  }
}
