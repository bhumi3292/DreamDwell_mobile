import React from "react";
import {
    FaFacebookF,
    FaTwitter,
    FaInstagram,
    FaLinkedinIn,
    FaEnvelope,
    FaPhone,
    FaHome,
} from "react-icons/fa";

export default function Footer() {
    return (
        <footer className="bg-[#0e1623] text-white w-full">
            {/* Inner container with max width and horizontal padding */}
            <div className="max-w-7xl mx-auto px-4 py-12 flex flex-col md:flex-row justify-between gap-12">
                {/* Brand & Description */}
                <div className="md:w-1/4">
                    <div className="flex items-center gap-2 mb-4">
                        <FaHome className="text-blue-500 text-2xl" />
                        <span className="text-2xl font-bold text-white">DreamDwell</span>
                    </div>
                    <p className="text-gray-400 mb-4">
                        Your trusted partner in finding the perfect rental property. <br />
                        Making dreams come true, one home at a time.
                    </p>
                    <div className="flex gap-4 text-xl text-gray-400">
                        <FaFacebookF className="hover:text-white cursor-pointer" />
                        <FaTwitter className="hover:text-white cursor-pointer" />
                        <FaInstagram className="hover:text-white cursor-pointer" />
                        <FaLinkedinIn className="hover:text-white cursor-pointer" />
                    </div>
                </div>

                {/* Quick Links */}
                <div className="md:w-1/5">
                    <h3 className="text-lg font-semibold mb-4">Quick Links</h3>
                    <ul className="space-y-2 text-gray-400">
                        <li className="hover:text-white cursor-pointer">Home</li>
                        <li className="hover:text-white cursor-pointer">Browse Properties</li>
                        <li className="hover:text-white cursor-pointer">About Us</li>
                        <li className="hover:text-white cursor-pointer">Blog</li>
                        <li className="hover:text-white cursor-pointer">Contact</li>
                    </ul>
                </div>

                {/* Support */}
                <div className="md:w-1/5">
                    <h3 className="text-lg font-semibold mb-4">Support</h3>
                    <ul className="space-y-2 text-gray-400">
                        <li className="hover:text-white cursor-pointer">Help Center</li>
                        <li className="hover:text-white cursor-pointer">FAQ</li>
                        <li className="hover:text-white cursor-pointer">Terms of Service</li>
                        <li className="hover:text-white cursor-pointer">Privacy Policy</li>
                    </ul>
                </div>

                {/* Contact Info */}
                <div className="md:w-1/4">
                    <h3 className="text-lg font-semibold mb-4">Contact Us</h3>
                    <div className="text-gray-400 space-y-3">
                        <p className="flex items-center gap-2">
                            <FaEnvelope /> hello@dreamdwell.com
                        </p>
                        <p className="flex items-center gap-2">
                            <FaPhone /> (555) 123-4567
                        </p>
                    </div>
                </div>
            </div>

            {/* Bottom Border */}
            <div className="border-t border-gray-700 mt-4"></div>
        </footer>
    );
}
