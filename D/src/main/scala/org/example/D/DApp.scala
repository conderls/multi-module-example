package org.example.D

import com.github.nscala_time.time.Imports.DateTime
import org.example.B.BApp
import org.example.C.CApp

object DApp {
  def call: String = {
    println(s"Called In D: ${BApp.call}")
    println(s"Called In D: ${CApp.call}")
    s"${DateTime.now}: D Called"
  }
}
