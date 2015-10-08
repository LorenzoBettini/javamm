package javamm.util;

import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 * Utility class with methods for requesting input using a Swing dialog.
 * 
 * @author Pierluigi Crescenzi - Initial contribution and API
 * @since 1.3
 */
public class Input {
	public static int getInt(String message) {
		InputFrame inf = new InputFrame(message);
		String text = inf.text;
		int number = 0;
		boolean done = false;
		while (!done) {
			try {
				number = Integer.parseInt(text);
				done = true;
			} catch (NumberFormatException nfe) {
				System.out.println("HERE");
				continue;
			}
		}
		return (number);
	}

	public static long getLong(String message) {
		InputFrame inf = new InputFrame(message);
		String text = inf.text;
		long number;
		try {
			number = Long.parseLong(text);
		} catch (NumberFormatException nfe) {
			number = 0;
		}
		return (number);
	}

	public static double getDouble(String message) {
		InputFrame inf = new InputFrame(message);
		String text = inf.text;
		double number;
		try {
			number = Double.parseDouble(text);
		} catch (NumberFormatException nfe) {
			number = 0;
		}
		return (number);
	}

	public static char getChar(String message) {
		InputFrame inf = new InputFrame(message);
		if (inf.text.length() > 0) {
			return (inf.text.charAt(0));
		} else {
			return (' ');
		}
	}

	public static String getString(String message) {
		InputFrame inf = new InputFrame(message);
		return (inf.text);
	}
}

class InputFrame extends JFrame {
	private static final long serialVersionUID = 1L;

	String text;

	public InputFrame(String message) {
		super();
		text = JOptionPane.showInputDialog(this, message);
		dispose();
	}
}
