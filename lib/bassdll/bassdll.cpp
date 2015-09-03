/* 
 * Copyright (c) 2009 Drew Crawford
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#include "bassdll.h"

void channel::next() {
	duration_sum += get_note(current).duration * 10;
	current++;
	if (current == pattern_len)
		current = 0;
}

channel::channel(int apin, int how_many_notes) {
	pinMode(apin, OUTPUT);
	halflife = 0;
	pin = apin;
	pattern_len = 0;
	init();
}

void channel::set_pattern(const uint16_t* pattern, int pattern_len) {
	this->pattern = pattern;
	this->pattern_len = pattern_len;
}

void channel::init() {
	nextTime = micros(); //YES, YOU NEED THIS HERE.  THINK ABOUT IT.
	position = LOW;
	duration_sum = 0;
	transpose = 0;
	supersolo = 0;
	notehack.i = 0;
	current = 0;
	ssinterval = UCHAR_MAX;
}

void channel::setupNote(unsigned long started_playing_time) {
	note solonote = get_note(current);

	switch (get_note(current).tone) {
	//hacks for various notes
	case KICK:
		halflife = 500000 / 200;
		break;
	case SNARE:
		halflife = 500000 / 345;
		break;
		//otherwise (square halflife)
	case TRANSPOSEUP:
		halflife = INT_MAX;
		transpose++;
		break;
	case TRANSPOSEDOWN:
		transpose--;
		halflife = INT_MAX;
		break;
	case SUPERSOLO:
		supersolo = solonote.duration;
		current++;
		if (current == pattern_len)
			current = 0;
		setupNote(started_playing_time); //fake out everything
		return;
		break;
	default:
		halflife = 500000 / fixTone(get_note(current).tone + transpose);
		break;
	}
	if (halflife < 0)
		halflife = INT_MAX; //we use negative number on occasion for things like rests...
	unsigned long old_nextTime = nextTime;
	nextTime = started_playing_time + ((unsigned long) //instruct the compiler that this is going to get BIG... otherwise things overflow here
	duration_sum + get_note(current).duration * 10) * 1000;
	next_invert_time = old_nextTime + halflife;

}

void mixer::dump() {
	for (int i = 0; i < max_channel; i++) {
		channel* c = channels[i];
		Serial.print("Channel ");
		Serial.println(i);
		for (int j = 0; j < c->pattern_len; j++) {
			note n = c->get_note(j);
			Serial.print("(");
			Serial.print(n.tone);
			Serial.print(", ");
			Serial.print(n.duration);
			Serial.print("), ");
		}
		Serial.println("");
	}
}

channel::~channel() {
}

inline void channel::notehacks() {
	switch (get_note(current).tone) {
	case KICK:
		notehack.i++;

		if (notehack.i >= 10) {
			notehack.i = 0;
			halflife *= 1.05;
		}
		break;
	case SNARE:
		notehack.i++;

		if (notehack.i == 10) {
			notehack.i = 0;
			halflife *= 1.05;
		}
		break;
	default:
		break;
	}
	//supersolo hack
	if (supersolo != 0 && (ssinterval--) % supersolo == 0) {
		char super =
				(get_note(current + 1).tone > get_note(current).tone) ? -1 : 1;
		// halflife *= ((1 + (.01*super)) * supersolo/10.);
		halflife += super;
	}
}
//MIXER////////////////////////
mixer::mixer() {
	max_channel = 0;
}
void mixer::play() {
	//dump();
	unsigned long lastClock = micros();
	unsigned long wall_clock_time = micros();
	for (int i = 0; i < max_channel; i++) {
		channels[i]->init();
		channels[i]->setupNote(wall_clock_time);
	}
	while (true) {
		//loop through each channel
		unsigned long minDelay = ULONG_MAX;
		channel* active = NULL;

		for (int i = 0; i < max_channel; i++) {

			if (channels[i]->get_note(channels[i]->current).tone == STOP)
				return;
			if (channels[i]->next_invert_time < minDelay) {
				minDelay = channels[i]->next_invert_time;
				active = channels[i];
			}
		}
		//BLOCK
		if (active->get_note(active->current).tone != REST)
			active->position = !active->position;
		while (micros() < minDelay) {
		}
		lastClock = micros();

		digitalWrite(active->pin, active->position);
		active->notehacks();
		active->next_invert_time += active->halflife;

		for (int i = 0; i < max_channel; i++) {
			if (lastClock >= channels[i]->nextTime) {
				channels[i]->next();
				channels[i]->setupNote(wall_clock_time);
			}
		}
	}
}
void mixer::add_channel(channel* x) {
	channels[max_channel++] = x;

}

