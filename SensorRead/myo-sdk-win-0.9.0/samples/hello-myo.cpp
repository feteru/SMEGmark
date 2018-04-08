// Copyright (C) 2013-2014 Thalmic Labs Inc.
// Distributed under the Myo SDK license agreement. See LICENSE.txt for details.
#define _USE_MATH_DEFINES
#include <cmath>
#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <string>
#include <algorithm>
//#include <array>
#include <fstream>

// The only file that needs to be included to use the Myo C++ SDK is myo.hpp.
#include <myo/myo.hpp>

// Classes that inherit from myo::DeviceListener can be used to receive events from Myo devices. DeviceListener
// provides several virtual functions for handling different kinds of events. If you do not override an event, the
// default behavior is to do nothing.
class DataCollector : public myo::DeviceListener {
public:
    DataCollector()
		: onArm(false), isUnlocked(false), roll_w{ 0,0 }, pitch_w{ 0,0 }, yaw_w{ 0,0 }, roll{ 0,0 }, yaw{ 0,0 }, pitch{ 0,0 }, gyrox{ 0,0 }, gyroy{ 0,0 }, gyroz{ 0,0 }, accelx{ 0,0 }, accely{ 0,0 }, accelz{ 0,0 }, emgOver{ 0,0 }, currentPose()
    {
		if (logFile.is_open()) {
			logFile.close();
		}
		logFile.open("logFile.csv", std::ios::out);
    }

	void onPair(myo::Myo* myo, uint64_t timestamp, myo::FirmwareVersion firmwareVersion)
	{
		// Print out the MAC address of the armband we paired with.

		// The pointer address we get for a Myo is unique - in other words, it's safe to compare two Myo pointers to
		// see if they're referring to the same Myo.

		// Add the Myo pointer to our list of known Myo devices. This list is used to implement identifyMyo() below so
		// that we can give each Myo a nice short identifier.
		knownMyos.push_back(myo);

		// Now that we've added it to our list, get our short ID for it and print it out.
		std::cout << "Paired with " << identifyMyo(myo) << "." << std::endl;
	}

    // onUnpair() is called whenever the Myo is disconnected from Myo Connect by the user.
    void onUnpair(myo::Myo* myo, uint64_t timestamp)
    {
        // We've lost a Myo.
        // Let's clean up some leftover state.
		roll_w[0] = 0; roll_w[1] = 0;
        pitch_w[0] = 0; pitch_w[1] = 0;
        yaw_w[0] = 0; yaw_w[1] = 0;
		roll[0] = 0; roll[1] = 0;
		pitch[0] = 0; pitch[1] = 0;
		yaw[0] = 0; yaw[1] = 0;
		gyrox[0] = 0; gyrox[1] = 0;
		gyroy[0] = 0; gyroy[1] = 0;
		gyroz[0] = 0; gyroz[1] = 0;
		accelx[0] = 0; accelx[1] = 0;
		accely[0] = 0; accely[1] = 0;
		accelz[0] = 0; accelz[1] = 0;
		emgOver[0] = 0; emgOver[1] = 0;
        onArm = false;
        isUnlocked = false;
    }

    // onOrientationData() is called whenever the Myo device provides its current orientation, which is represented
    // as a unit quaternion.
    void onOrientationData(myo::Myo* myo, uint64_t timestamp, const myo::Quaternion< float > &quat)
    {
        using std::atan2;
        using std::asin;
        using std::sqrt;
        using std::max;
        using std::min;

		int which = (int)(identifyMyo(myo)-1); 

        // Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
        /*roll[which] = static_cast<float> (atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                           1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y())));
        pitch[which] = static_cast<float> (asin(max(-1.0f, min(1.0f, 2.0f * (quat.w() * quat.y() - quat.z() * quat.x())))));
        yaw[which] = static_cast<float> (atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                        1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z())));

        // Convert the floating point angles in radians to a scale from 0 to 18.
        roll_w[which] = static_cast<int>((roll[which] + (float)M_PI)/(M_PI * 2.0f) * 18);
        pitch_w[which] = static_cast<int>((pitch[which] + (float)M_PI/2.0f)/M_PI * 18);
        yaw_w[which] = static_cast<int>((yaw[which] + (float)M_PI)/(M_PI * 2.0f) * 18);*/

		roll_w[which] = static_cast<int>(((atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
			1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()))) + (float)M_PI) / (M_PI * 2.0f) * 18);
		pitch_w[which] = static_cast<int>(((asin(max(-1.0f, min(1.0f, 2.0f * (quat.w() * quat.y() - quat.z() * quat.x()))))) + (float)M_PI / 2.0f) / M_PI * 18);
		yaw_w[which] = static_cast<int>(((atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
			1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()))) + (float)M_PI) / (M_PI * 2.0f) * 18);
		
		//std::cout << "0:" << yaw_w[0] << "\t\t\t1:" << yaw_w[1] << std::endl;
    }

    // onPose() is called whenever the Myo detects that the person wearing it has changed their pose, for example,
    // making a fist, or not making a fist anymore.
    /*void onPose(myo::Myo* myo, uint64_t timestamp, myo::Pose pose)
    {
        currentPose = pose;

        if (pose != myo::Pose::unknown && pose != myo::Pose::rest) {
            // Tell the Myo to stay unlocked until told otherwise. We do that here so you can hold the poses without the
            // Myo becoming locked.
            myo->unlock(myo::Myo::unlockHold);

            // Notify the Myo that the pose has resulted in an action, in this case changing
            // the text on the screen. The Myo will vibrate.
            myo->notifyUserAction();
        } else {
            // Tell the Myo to stay unlocked only for a short period. This allows the Myo to stay unlocked while poses
            // are being performed, but lock after inactivity.
            myo->unlock(myo::Myo::unlockTimed);
        }
    }*/

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

    // onUnlock() is called whenever Myo h  as become unlocked, and will start delivering pose events.
    void onUnlock(myo::Myo* myo, uint64_t timestamp)
    {
        isUnlocked = true;
    }

    // onLock() is called whenever Myo has become locked. No pose events will be sent until the Myo is unlocked again.
    void onLock(myo::Myo* myo, uint64_t timestamp)
    {
        isUnlocked = false;
    }

	void onConnect(myo::Myo* myo, uint64_t timestamp, myo::FirmwareVersion firmwareVersion)
	{
		std::cout << "Myo " << identifyMyo(myo) << " has connected." << std::endl;
	}

	void onDisconnect(myo::Myo* myo, uint64_t timestamp)
	{
		std::cout << "Myo " << identifyMyo(myo) << " has disconnected." << std::endl;
	}

    // There are other virtual functions in DeviceListener that we could override here, like onAccelerometerData().
    // For this example, the functions overridden above are sufficient.

	void onAccelerometerData(myo::Myo *myo, uint64_t timestamp, const myo::Vector3< float > &accel) {
		//std::cout << "ACCELEROMETER DATA" << std::endl;
		int which = (int)(identifyMyo(myo) - 1);

		accelx[which] = static_cast<float>(accel.x());
		accely[which] = static_cast<float>(accel.y());
		accelz[which] = static_cast<float>(accel.z());
	}
	void onGyroscopeData(myo::Myo *myo, uint64_t timestamp, const myo::Vector3< float > &gyro) {
		//std::cout << "GYRO DATA" << std::endl;
		int which = (int)(identifyMyo(myo) - 1);

		gyrox[which] = static_cast<float>(gyro.x());
		gyroy[which] = static_cast<float>(gyro.y());
		gyroz[which] = static_cast<float>(gyro.z());
	}

	// onEmgData() is called whenever a paired Myo has provided new EMG data, and EMG streaming is enabled.
	void onEmgData(myo::Myo* myo, uint64_t timestamp, const int8_t* emg)
	{
		int which = (int)(identifyMyo(myo) - 1);
		//emgOver[which] = 0;
		for (int i = 0; i < 8; i++) {
			if (emg[i] > 0.5) {
				emgOver[which]++;
				//emgSamples[i] = 1;
			}
			//else emgSamples[i] = 0;
		}
	}
	size_t identifyMyo(myo::Myo* myo) {
		// Walk through the list of Myo devices that we've seen pairing events for.
		for (size_t i = 0; i < knownMyos.size(); ++i) {
			// If two Myo pointers compare equal, they refer to the same Myo device.
			if (knownMyos[i] == myo) {
				return i + 1;
			}
		}

		return 0;
	}

    // We define this function to print the current values that were updated by the on...() functions above.
    void print()
    {
        // Clear the current line
        std::cout << '\r';

        // Print out the orientation. Orientation data is always available, even if no arm is currently recognized.
		std::cout << "[RollL: " << roll_w[0] << "\tPitchL: " << pitch_w[0] << "\tYawL: " << yaw_w[0] << "] [RollR: "<< roll_w[1] << ",\tPitchR: " << pitch_w[1] << ",\tYawR: " << yaw_w[1] << ']';
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
		if (outFile.is_open()) {
			outFile.close();
		}
		outFile.open("outFile.txt", std::ios::out);

		outFile << roll_w[0] << ',' << pitch_w[0] << ',' << yaw_w[0] << '|' << accelx[0] << ',' << accely[0] << ',' << accelz[0] << '|' << gyrox[0] << ',' << gyroy[0] << ',' << gyroz[0] << '|' << emgOver[0] << ';' << roll_w[1] << ',' << pitch_w[1] << ',' << yaw_w[1] << '|' << accelx[1] << ',' << accely[1] << ',' << accelz[1] << '|' << gyrox[1] << ',' << gyroy[1] << ',' << gyroz[1] << '|' << emgOver[1] << std::endl;
		outFile.close();

		logFile << roll_w[0] << ',' << pitch_w[0] << ',' << yaw_w[0] << ',' << accelx[0] << ',' << accely[0] << ',' << accelz[0] << ',' << gyrox[0] << ',' << gyroy[0] << ',' << gyroz[0] << ',' << emgOver[0] << ',' << roll_w[1] << ',' << pitch_w[1] << ',' << yaw_w[1] << ',' << accelx[1] << ',' << accely[1] << ',' << accelz[1] << ',' << gyrox[1] << ',' << gyroy[1] << ',' << gyroz[1] << ',' << emgOver[1] << std::endl;
    }

    // These values are set by onArmSync() and onArmUnsync() above.
    bool onArm;
    myo::Arm whichArm;

    // This is set by onUnlocked() and onLocked() above.
    bool isUnlocked;

    // These values are set by onOrientationData() and onPose() above.
    int roll_w[2], pitch_w[2], yaw_w[2];
	float roll[2], pitch[2], yaw[2];
	float accelx[2], accely[2], accelz[2];
	float gyrox[2], gyroy[2], gyroz[2];
	int emgOver[2];
    myo::Pose currentPose;
	//std::array<int8_t, 8> emgSamples;

	std::ofstream outFile;
	std::ofstream logFile;
	std::vector<myo::Myo*> knownMyos;
};

int main(int argc, char** argv)
{
    // We catch any exceptions that might occur below -- see the catch statement for more details.
    try {

    // First, we create a Hub with our application identifier. Be sure not to use the com.example namespace when
    // publishing your application. The Hub provides access to one or more Myos.
    myo::Hub hub("com.example.hello-myo");

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
    std::cout << "Connected to a Myo armband!" << std::endl << std::endl;

    // Next we construct an instance of our DeviceListener, so that we can register it with the Hub.
    DataCollector collector;

    // Hub::addListener() takes the address of any object whose class inherits from DeviceListener, and will cause
    // Hub::run() to send events to all registered device listeners.
    hub.addListener(&collector);

    // Finally we enter our main loop.
    while (1) {
        // In each iteration of our main loop, we run the Myo event loop for a set number of milliseconds.
        // In this case, we wish to update our display 20 times a second, so we run for 1000/20 milliseconds.
        hub.run(1000/20);
        // After processing events, we call the print() member function we defined above to print out the values we've
        // obtained from any events that have occurred.
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
