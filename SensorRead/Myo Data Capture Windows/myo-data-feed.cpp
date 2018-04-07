// Copyright (C) 2013-2014 Thalmic Labs Inc.
// Distributed under the Myo SDK license agreement. See LICENSE.txt for details.

// This sample illustrates how to log EMG and IMU data. EMG streaming is only supported for one Myo at a time, and this entire sample is geared to one armband

#define _USE_MATH_DEFINES
#include <cmath>
#include <iomanip>
#include <algorithm>
#include <array>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <fstream>

#include <myo/myo.hpp>

class DataCollector : public myo::DeviceListener {
public:
	DataCollector() : onArm(false), isUnlocked(false), roll_w(0), pitch_w(0), yaw_w(0), roll(0), yaw(0), pitch(0), gyrox(0), gyroy(0), gyroz(0), accelx(0), accely(0), accelz(0), currentPose()
	{
    }

	// onUnpair() is called whenever the Myo is disconnected from Myo Connect by the user.
	void onUnpair(myo::Myo* myo, uint64_t timestamp)
	{
		// We've lost a Myo.
		// Let's clean up some leftover state.
		roll_w = 0;
		pitch_w = 0;
		yaw_w = 0;
		roll = 0; 
		pitch = 0; 
		yaw = 0;
		gyrox = 0; 
		gyroy = 0; 
		gyroz = 0;
		accelx = 0; 
		accely = 0; 
		accelz = 0;
		onArm = false;
		isUnlocked = false;
	}

	// onPose() is called whenever the Myo detects that the person wearing it has changed their pose, for example,
	// making a fist, or not making a fist anymore.
	void onPose(myo::Myo* myo, uint64_t timestamp, myo::Pose pose)
	{
		currentPose = pose;

		if (pose != myo::Pose::unknown && pose != myo::Pose::rest) {
			// Tell the Myo to stay unlocked until told otherwise. We do that here so you can hold the poses without the
			// Myo becoming locked.
			myo->unlock(myo::Myo::unlockHold);

			// Notify the Myo that the pose has resulted in an action, in this case changing
			// the text on the screen. The Myo will vibrate.
			myo->notifyUserAction();
		}
		else {
			// Tell the Myo to stay unlocked only for a short period. This allows the Myo to stay unlocked while poses
			// are being performed, but lock after inactivity.
			myo->unlock(myo::Myo::unlockTimed);
		}
	}

	// onArmSync() is called whenever Myo has recognized a Sync Gesture after someone has put it on their
	// arm. This lets Myo know which arm it's on and which way it's facing.
	void onArmSync(myo::Myo* myo, uint64_t timestamp, myo::Arm arm, myo::XDirection xDirection, float rotation,
		myo::WarmupState warmupState)
	{
		onArm = true;
		whichArm = arm;
	}

	// onArmUnsync() is called whenever Myo has detected that it was moved from a stable position on a person's arm after
	// it recognized the arm. Typically this happens when someone takes Myo off of their arm, but it can also happen
	// when Myo is moved around on the arm.
	void onArmUnsync(myo::Myo* myo, uint64_t timestamp)
	{
		onArm = false;
	}

	// onUnlock() is called whenever Myo has become unlocked, and will start delivering pose events.
	void onUnlock(myo::Myo* myo, uint64_t timestamp)
	{
		isUnlocked = true;
	}

	// onLock() is called whenever Myo has become locked. No pose events will be sent until the Myo is unlocked again.
	void onLock(myo::Myo* myo, uint64_t timestamp)
	{
		isUnlocked = false;
	}

    // onEmgData() is called whenever a paired Myo has provided new EMG data, and EMG streaming is enabled.
    /*void onEmgData(myo::Myo* myo, const int8_t* emg)
    {
		//std::cout << "EMG DATA" << std::endl;
		// Open file for EMG log
		if (emgFile.is_open()) {
			emgFile.close();
		}
		std::ostringstream emgFileString;
		emgFileString << "emg.txt";
		emgFile.open(emgFileString.str(), std::ios::out);
		for (size_t i = 0; i < 8; i++) {
			emgFile << ',' << static_cast<int>(emg[i]);
		}
		emgFile << std::endl;
		emgFile.close();
    }*/

	// onOrientationData is called whenever new orientation data is provided
	// Be warned: This will not make any distiction between data from other Myo armbands
	void onOrientationData(myo::Myo *myo, const myo::Quaternion< float > &rotation) {
		//std::cout << "ORIENTATION DATA" << std::endl;

		using std::atan2;
		using std::asin;
		using std::sqrt;
		using std::max;
		using std::min;

		// Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
		roll = static_cast<float>(atan2(2.0f * (rotation.w() * rotation.x() + rotation.y() * rotation.z()),
			1.0f - 2.0f * (rotation.x() * rotation.x() + rotation.y() * rotation.y())));
		pitch = static_cast<float>(asin(max(-1.0f, min(1.0f, 2.0f * (rotation.w() * rotation.y() - rotation.z() * rotation.x())))));
		yaw = static_cast<float>(atan2(2.0f * (rotation.w() * rotation.z() + rotation.x() * rotation.y()),
			1.0f - 2.0f * (rotation.y() * rotation.y() + rotation.z() * rotation.z())));

		// Convert the floating point angles in radians to a scale from 0 to 18.
		roll_w = static_cast<int>((roll + (float)M_PI) / (M_PI * 2.0f) * 18);
		pitch_w = static_cast<int>((pitch + (float)M_PI / 2.0f) / M_PI * 18);
		yaw_w = static_cast<int>((yaw + (float)M_PI) / (M_PI * 2.0f) * 18);

		// Open file for orientation (Euler angles) log
		if (orientationEulerFile.is_open()) {
			orientationEulerFile.close();
		}
		std::ostringstream orientationEulerFileString;
		orientationEulerFileString << "orientationEuler.txt";
		orientationEulerFile.open(orientationEulerFileString.str(), std::ios::out);
		orientationEulerFile << roll_w << ',' << pitch_w << ',' << yaw_w << std::endl;
	}

	// onAccelerometerData is called whenever new acceleromenter data is provided
	// Be warned: This will not make any distiction between data from other Myo armbands
	void onAccelerometerData(myo::Myo *myo, const myo::Vector3< float > &accel) {
		//std::cout << "ACCELEROMETER DATA" << std::endl;
		printAccelVector(accel);
	}

	// onGyroscopeData is called whenever new gyroscope data is provided
	// Be warned: This will not make any distiction between data from other Myo armbands
	void onGyroscopeData(myo::Myo *myo, const myo::Vector3< float > &gyro) {
		//std::cout << "GYRO DATA" << std::endl;
		printGyroVector(gyro);
	}

	void onConnect(myo::Myo *myo, myo::FirmwareVersion firmwareVersion) {
		//Reneable streaming
		myo->setStreamEmg(myo::Myo::streamEmgEnabled);
	}
  
	// Helper to print out accelerometer and gyroscope vectors
	void printAccelVector(const myo::Vector3< float > &vector) {
		accelx = static_cast<float>(vector.x());
		accely = static_cast<float>(vector.y());
		accelz = static_cast<float>(vector.z());
	}
	void printGyroVector(const myo::Vector3< float > &vector) {
		gyrox = static_cast<float>(vector.x());
		gyroy = static_cast<float>(vector.y());
		gyroz = static_cast<float>(vector.z());
	}

	void print()
	{
		// Clear the current line
		std::cout << '\r';

		// Print out the orientation. Orientation data is always available, even if no arm is currently recognized.
		std::cout << "[Roll: " << roll_w << "\t Pitch: " << pitch_w << "\t Yaw: " << yaw_w << ']';
		/*std::cout << '[' << std::string(roll_w, '*') << std::string(18 - roll_w, ' ') << ']'
		<< '[' << std::string(pitch_w, '*') << std::string(18 - pitch_w, ' ') << ']'
		<< '[' << std::string(yaw_w, '*') << std::string(18 - yaw_w, ' ') << ']';

		if (onArm) {
		// Print out the lock state, the currently recognized pose, and which arm Myo is being worn on.

		// Pose::toString() provides the human-readable name of a pose. We can also output a Pose directly to an
		// output stream (e.g. std::cout << currentPose;). In this case we want to get the pose name's length so
		// that we can fill the rest of the field with spaces below, so we obtain it as a string using toString().
		std::string poseString = currentPose.toString();

		std::cout << '[' << (isUnlocked ? "unlocked" : "locked  ") << ']'
		<< '[' << (whichArm == myo::armLeft ? "L" : "R") << ']'
		<< '[' << poseString << std::string(14 - poseString.size(), ' ') << ']';
		} else {
		// Print out a placeholder for the arm and pose when Myo doesn't currently know which arm it's on.
		std::cout << '[' << std::string(8, ' ') << ']' << "[?]" << '[' << std::string(14, ' ') << ']';
		}*/

		std::cout << std::flush;

		// Open file for orientation log
		/*if (orientationFile.is_open()) {
			orientationFile.close();
		}
		std::ostringstream orientationFileString;
		orientationFileString << "orientation.txt";
		orientationFile.open(orientationFileString.str(), std::ios::out);
		orientationFile << roll << ',' << pitch << ',' << yaw << std::endl;
		orientationFile.close();

		if (orientationEulerFile.is_open()) {
			orientationEulerFile.close();
		}
		orientationEulerFile.open("outFile.txt", std::ios::out);
		orientationEulerFile << roll_w << ',' << pitch_w << ',' << yaw_w << std::endl;
		orientationEulerFile.close();

		// Open file for gyroscope log
		if (gyroFile.is_open()) {
			gyroFile.close();
		}
		std::ostringstream gyroFileString;
		gyroFileString << "gyro.txt";
		gyroFile.open(gyroFileString.str(), std::ios::out);
		gyroFile << gyrox << ',' << gyroy << ',' << gyroz << std::endl;
		gyroFile.close();

		// Open file for accelerometer log
		if (accelerometerFile.is_open()) {
			accelerometerFile.close();
		}
		std::ostringstream accelerometerFileString;
		accelerometerFileString << "accelerometer.txt";
		accelerometerFile.open(accelerometerFileString.str(), std::ios::out);
		accelerometerFile << accelx << ',' << accely << ',' << accelz << std::endl;
		accelerometerFile.close();*/
	}
	// These values are set by onArmSync() and onArmUnsync() above.
	bool onArm;
	myo::Arm whichArm;

	// This is set by onUnlocked() and onLocked() above.
	bool isUnlocked;

	// These values are set by onOrientationData() and onPose() above.
	int roll_w, pitch_w, yaw_w;
	float roll, pitch, yaw;
	float gyrox, gyroy, gyroz;
	float accelx, accely, accelz;
	myo::Pose currentPose;

	// The files we are logging to
	std::ofstream emgFile;
	std::ofstream gyroFile;
	std::ofstream orientationFile;
	std::ofstream orientationEulerFile;
	std::ofstream accelerometerFile;

};

int main(int argc, char** argv)
{
    // We catch any exceptions that might occur below -- see the catch statement for more details.
    try {

    // First, we create a Hub with our application identifier. Be sure not to use the com.example namespace when
    // publishing your application. The Hub provides access to one or more Myos.
    myo::Hub hub("com.undercoveryeti.myo-data-capture");

    std::cout << "Attempting to find a Myo..." << std::endl;

    // Next, we attempt to find a Myo to use. If a Myo is already paired in Myo Connect, this will return that Myo
    // immediately.
    // waitForMyo() takes a timeout value in milliseconds. In this case we will try to find a Myo for 10 seconds, and
    // if that fails, the function will return a null pointer.
    myo::Myo* myo = hub.waitForMyo(10000);

    // If waitForMyo() returned a null pointer, we failed to find a Myo, so exit with an error message.
    if (!myo) {
        throw std::runtime_error("Unable to find a Myo!");
    }

    // We've found a Myo.
    std::cout << "Connected to a Myo armband! Logging to the file system. Check your home folder or the folder this application lives in." << std::endl << std::endl;

    // Next we enable EMG streaming on the found Myo.
    myo->setStreamEmg(myo::Myo::streamEmgEnabled);

    // Next we construct an instance of our DeviceListener, so that we can register it with the Hub.
    DataCollector collector;

    // Hub::addListener() takes the address of any object whose class inherits from DeviceListener, and will cause
    // Hub::run() to send events to all registered device listeners.
    hub.addListener(&collector);

    // Finally we enter our main loop.
    while (1) {
        // In each iteration of our main loop, we run the Myo event loop for a set number of milliseconds.
        // In this case, we wish to update our display 50 times a second, so we run for 1000/20 milliseconds.
        hub.run(1000/20);
		collector.print();
    }

    // If a standard exception occurred, we print out its message and exit.
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        std::cerr << "Press enter to continue.";
        std::cin.ignore();
        return 1;
    }
}
