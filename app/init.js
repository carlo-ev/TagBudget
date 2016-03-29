console.log('running init?');

module.exports = function(){

	window.App = Ember.Application.create({
		rootElement: '#appContainer'
	});

	require('modules/router');
	['routes','controllers','views'].forEach(function(folder){
		window.require.list().filter(function(module){
			return new RegExp('^'+folder+'/').test(module);
		}).forEach(function(module){
			console.log('the modules from list ', module);
			require(module);
		});
	});

}