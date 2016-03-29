module.exports = App.IndexRoute = Ember.Route.extend({
	model: function(){ return Ember.$.getJSON('/transactions'); }
});