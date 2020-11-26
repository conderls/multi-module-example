package org.example.C

import com.github.nscala_time.time.Imports.DateTime
import org.example.A.App

object CApp {
  def call: String = {
    println(s"Called In C: ${App.call}")
    s"${DateTime.now}: C Called"
  }
}
