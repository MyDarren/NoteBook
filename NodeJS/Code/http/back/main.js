
console.log('hello,javascript');

window.onload = function(){
	var video = document.getElementById('video');
	video.onclick = function(){
		window.location.href = '404.html';
	};
};
