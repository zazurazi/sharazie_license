const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

// Use environment variables for email credentials
const gmailEmail = functions.config().email.user;
const gmailPassword = functions.config().email.pass;

// Configure the email transport using the SMTP transport and Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

// Cloud Function to send OTP email
exports.sendOtpEmail = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const otp = data.otp;

  const mailOptions = {
    from: `Sharazie License <${gmailEmail}>`,
    to: email,
    subject: "Your OTP Code",
    text: `Your OTP code is: ${otp}. It is valid for 5 minutes.`,
  };

  try {
    await transporter.sendMail(mailOptions);
    return {success: true, message: "OTP sent successfully"};
  } catch (error) {
    return {success: false, message: error.toString()};
  }
});
