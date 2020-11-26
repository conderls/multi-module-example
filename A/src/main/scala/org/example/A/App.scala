package org.example.A

import com.github.nscala_time.time.Imports.DateTime

object App {
  def call = s"${DateTime.now}: Hello world!"
}
