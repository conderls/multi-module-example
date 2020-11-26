package org.example.B

import org.example.A.App
import com.github.nscala_time.time.Imports.DateTime

object BApp {
  def call: String = {
    println(s"Called In B: ${App.call}")
    s"${DateTime.now}: B Called"
  }
}
