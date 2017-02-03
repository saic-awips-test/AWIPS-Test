/**
 * Autogenerated by Thrift Compiler (0.9.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

/*****************************************************************************************
 * COPYRIGHT (c), 2009, RAYTHEON COMPANY
 * ALL RIGHTS RESERVED, An Unpublished Work
 *
 * RAYTHEON PROPRIETARY
 * If the end user is not the U.S. Government or any agency thereof, use
 * or disclosure of data contained in this source code file is subject to
 * the proprietary restrictions set forth in the Master Rights File.
 *
 * U.S. GOVERNMENT PURPOSE RIGHTS NOTICE
 * If the end user is the U.S. Government or any agency thereof, this source
 * code is provided to the U.S. Government with Government Purpose Rights.
 * Use or disclosure of data contained in this source code file is subject to
 * the "Government Purpose Rights" restriction in the Master Rights File.
 *
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * Use or disclosure of data contained in this source code file is subject to
 * the export restrictions set forth in the Master Rights File.
 ******************************************************************************************/

/*
 * Extended thrift protocol to handle messages from edex.
 *
 * <pre>
 *
 * SOFTWARE HISTORY
 *
 * Date         Ticket#     Engineer    Description
 * ------------ ----------  ----------- --------------------------
 * 07/29/13       2215       bkowal     Regenerated for thrift 0.9.0
 *
 * </pre>
 *
 * @author bkowal
 * @version 1
 */
#ifndef PointData_TYPES_H
#define PointData_TYPES_H

#include <thrift/Thrift.h>
#include <thrift/TApplicationException.h>
#include <thrift/protocol/TProtocol.h>
#include <thrift/transport/TTransport.h>





typedef struct _com_raytheon_uf_common_pointdata_ParameterDescription__isset {
  _com_raytheon_uf_common_pointdata_ParameterDescription__isset() : dimension(false), dimensionAsInt(false), fillValue(false), maxLength(false), numDims(false), parameterName(false), unit(false) {}
  bool dimension;
  bool dimensionAsInt;
  bool fillValue;
  bool maxLength;
  bool numDims;
  bool parameterName;
  bool unit;
} _com_raytheon_uf_common_pointdata_ParameterDescription__isset;

class com_raytheon_uf_common_pointdata_ParameterDescription {
 public:

  static const char* ascii_fingerprint; // = "F8914BAC237E22C5EFA279EDDBA3C5C6";
  static const uint8_t binary_fingerprint[16]; // = {0xF8,0x91,0x4B,0xAC,0x23,0x7E,0x22,0xC5,0xEF,0xA2,0x79,0xED,0xDB,0xA3,0xC5,0xC6};

  com_raytheon_uf_common_pointdata_ParameterDescription() : dimension(), dimensionAsInt(0), fillValue(0), maxLength(0), numDims(0), parameterName(), unit() {
  }

  virtual ~com_raytheon_uf_common_pointdata_ParameterDescription() throw() {}

  std::string dimension;
  int32_t dimensionAsInt;
  double fillValue;
  int32_t maxLength;
  int32_t numDims;
  std::string parameterName;
  std::string unit;

  _com_raytheon_uf_common_pointdata_ParameterDescription__isset __isset;

  void __set_dimension(const std::string& val) {
    dimension = val;
  }

  void __set_dimensionAsInt(const int32_t val) {
    dimensionAsInt = val;
  }

  void __set_fillValue(const double val) {
    fillValue = val;
  }

  void __set_maxLength(const int32_t val) {
    maxLength = val;
  }

  void __set_numDims(const int32_t val) {
    numDims = val;
  }

  void __set_parameterName(const std::string& val) {
    parameterName = val;
  }

  void __set_unit(const std::string& val) {
    unit = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_ParameterDescription & rhs) const
  {
    if (!(dimension == rhs.dimension))
      return false;
    if (!(dimensionAsInt == rhs.dimensionAsInt))
      return false;
    if (!(fillValue == rhs.fillValue))
      return false;
    if (!(maxLength == rhs.maxLength))
      return false;
    if (!(numDims == rhs.numDims))
      return false;
    if (!(parameterName == rhs.parameterName))
      return false;
    if (!(unit == rhs.unit))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_ParameterDescription &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_ParameterDescription & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_ParameterDescription &a, com_raytheon_uf_common_pointdata_ParameterDescription &b);

typedef struct _com_raytheon_uf_common_pointdata_elements_StringPointDataObject__isset {
  _com_raytheon_uf_common_pointdata_elements_StringPointDataObject__isset() : description(false), dimensions(false), stringData(false) {}
  bool description;
  bool dimensions;
  bool stringData;
} _com_raytheon_uf_common_pointdata_elements_StringPointDataObject__isset;

class com_raytheon_uf_common_pointdata_elements_StringPointDataObject {
 public:

  static const char* ascii_fingerprint; // = "8432CD88CCBAE483EB61F9210360E5F9";
  static const uint8_t binary_fingerprint[16]; // = {0x84,0x32,0xCD,0x88,0xCC,0xBA,0xE4,0x83,0xEB,0x61,0xF9,0x21,0x03,0x60,0xE5,0xF9};

  com_raytheon_uf_common_pointdata_elements_StringPointDataObject() : dimensions(0) {
  }

  virtual ~com_raytheon_uf_common_pointdata_elements_StringPointDataObject() throw() {}

  com_raytheon_uf_common_pointdata_ParameterDescription description;
  int32_t dimensions;
  std::vector<std::string>  stringData;

  _com_raytheon_uf_common_pointdata_elements_StringPointDataObject__isset __isset;

  void __set_description(const com_raytheon_uf_common_pointdata_ParameterDescription& val) {
    description = val;
  }

  void __set_dimensions(const int32_t val) {
    dimensions = val;
  }

  void __set_stringData(const std::vector<std::string> & val) {
    stringData = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_elements_StringPointDataObject & rhs) const
  {
    if (!(description == rhs.description))
      return false;
    if (!(dimensions == rhs.dimensions))
      return false;
    if (!(stringData == rhs.stringData))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_elements_StringPointDataObject &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_elements_StringPointDataObject & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_elements_StringPointDataObject &a, com_raytheon_uf_common_pointdata_elements_StringPointDataObject &b);

typedef struct _com_raytheon_uf_common_pointdata_elements_FloatPointDataObject__isset {
  _com_raytheon_uf_common_pointdata_elements_FloatPointDataObject__isset() : description(false), dimensions(false), floatData(false), trueFloatData(false) {}
  bool description;
  bool dimensions;
  bool floatData;
  bool trueFloatData;
} _com_raytheon_uf_common_pointdata_elements_FloatPointDataObject__isset;

class com_raytheon_uf_common_pointdata_elements_FloatPointDataObject {
 public:

  static const char* ascii_fingerprint; // = "89584E5DAFB01EC75A91F6E88874692D";
  static const uint8_t binary_fingerprint[16]; // = {0x89,0x58,0x4E,0x5D,0xAF,0xB0,0x1E,0xC7,0x5A,0x91,0xF6,0xE8,0x88,0x74,0x69,0x2D};

  com_raytheon_uf_common_pointdata_elements_FloatPointDataObject() : dimensions(0) {
  }

  virtual ~com_raytheon_uf_common_pointdata_elements_FloatPointDataObject() throw() {}

  com_raytheon_uf_common_pointdata_ParameterDescription description;
  int32_t dimensions;
  std::vector<int32_t>  floatData;
  std::vector<double>  trueFloatData;

  _com_raytheon_uf_common_pointdata_elements_FloatPointDataObject__isset __isset;

  void __set_description(const com_raytheon_uf_common_pointdata_ParameterDescription& val) {
    description = val;
  }

  void __set_dimensions(const int32_t val) {
    dimensions = val;
  }

  void __set_floatData(const std::vector<int32_t> & val) {
    floatData = val;
  }

  void __set_trueFloatData(const std::vector<double> & val) {
    trueFloatData = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_elements_FloatPointDataObject & rhs) const
  {
    if (!(description == rhs.description))
      return false;
    if (!(dimensions == rhs.dimensions))
      return false;
    if (!(floatData == rhs.floatData))
      return false;
    if (!(trueFloatData == rhs.trueFloatData))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_elements_FloatPointDataObject &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_elements_FloatPointDataObject & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_elements_FloatPointDataObject &a, com_raytheon_uf_common_pointdata_elements_FloatPointDataObject &b);

typedef struct _com_raytheon_uf_common_pointdata_elements_IntPointDataObject__isset {
  _com_raytheon_uf_common_pointdata_elements_IntPointDataObject__isset() : description(false), dimensions(false), intData(false) {}
  bool description;
  bool dimensions;
  bool intData;
} _com_raytheon_uf_common_pointdata_elements_IntPointDataObject__isset;

class com_raytheon_uf_common_pointdata_elements_IntPointDataObject {
 public:

  static const char* ascii_fingerprint; // = "3E090BC5D21490BE0856576B426175A4";
  static const uint8_t binary_fingerprint[16]; // = {0x3E,0x09,0x0B,0xC5,0xD2,0x14,0x90,0xBE,0x08,0x56,0x57,0x6B,0x42,0x61,0x75,0xA4};

  com_raytheon_uf_common_pointdata_elements_IntPointDataObject() : dimensions(0) {
  }

  virtual ~com_raytheon_uf_common_pointdata_elements_IntPointDataObject() throw() {}

  com_raytheon_uf_common_pointdata_ParameterDescription description;
  int32_t dimensions;
  std::vector<int32_t>  intData;

  _com_raytheon_uf_common_pointdata_elements_IntPointDataObject__isset __isset;

  void __set_description(const com_raytheon_uf_common_pointdata_ParameterDescription& val) {
    description = val;
  }

  void __set_dimensions(const int32_t val) {
    dimensions = val;
  }

  void __set_intData(const std::vector<int32_t> & val) {
    intData = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_elements_IntPointDataObject & rhs) const
  {
    if (!(description == rhs.description))
      return false;
    if (!(dimensions == rhs.dimensions))
      return false;
    if (!(intData == rhs.intData))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_elements_IntPointDataObject &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_elements_IntPointDataObject & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_elements_IntPointDataObject &a, com_raytheon_uf_common_pointdata_elements_IntPointDataObject &b);

typedef struct _com_raytheon_uf_common_pointdata_elements_LongPointDataObject__isset {
  _com_raytheon_uf_common_pointdata_elements_LongPointDataObject__isset() : description(false), dimensions(false), longData(false) {}
  bool description;
  bool dimensions;
  bool longData;
} _com_raytheon_uf_common_pointdata_elements_LongPointDataObject__isset;

class com_raytheon_uf_common_pointdata_elements_LongPointDataObject {
 public:

  static const char* ascii_fingerprint; // = "135921A65C05459AFDDA382E27DDA225";
  static const uint8_t binary_fingerprint[16]; // = {0x13,0x59,0x21,0xA6,0x5C,0x05,0x45,0x9A,0xFD,0xDA,0x38,0x2E,0x27,0xDD,0xA2,0x25};

  com_raytheon_uf_common_pointdata_elements_LongPointDataObject() : dimensions(0) {
  }

  virtual ~com_raytheon_uf_common_pointdata_elements_LongPointDataObject() throw() {}

  com_raytheon_uf_common_pointdata_ParameterDescription description;
  int32_t dimensions;
  std::vector<int64_t>  longData;

  _com_raytheon_uf_common_pointdata_elements_LongPointDataObject__isset __isset;

  void __set_description(const com_raytheon_uf_common_pointdata_ParameterDescription& val) {
    description = val;
  }

  void __set_dimensions(const int32_t val) {
    dimensions = val;
  }

  void __set_longData(const std::vector<int64_t> & val) {
    longData = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_elements_LongPointDataObject & rhs) const
  {
    if (!(description == rhs.description))
      return false;
    if (!(dimensions == rhs.dimensions))
      return false;
    if (!(longData == rhs.longData))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_elements_LongPointDataObject &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_elements_LongPointDataObject & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_elements_LongPointDataObject &a, com_raytheon_uf_common_pointdata_elements_LongPointDataObject &b);

typedef struct _com_raytheon_uf_common_pointdata_PointDataThriftContainer__isset {
  _com_raytheon_uf_common_pointdata_PointDataThriftContainer__isset() : floatData(false), intData(false), longData(false), size(false), stringData(false) {}
  bool floatData;
  bool intData;
  bool longData;
  bool size;
  bool stringData;
} _com_raytheon_uf_common_pointdata_PointDataThriftContainer__isset;

class com_raytheon_uf_common_pointdata_PointDataThriftContainer {
 public:

  static const char* ascii_fingerprint; // = "8E622421D449B7CCD34FF11BE324DA19";
  static const uint8_t binary_fingerprint[16]; // = {0x8E,0x62,0x24,0x21,0xD4,0x49,0xB7,0xCC,0xD3,0x4F,0xF1,0x1B,0xE3,0x24,0xDA,0x19};

  com_raytheon_uf_common_pointdata_PointDataThriftContainer() : size(0) {
  }

  virtual ~com_raytheon_uf_common_pointdata_PointDataThriftContainer() throw() {}

  std::vector<com_raytheon_uf_common_pointdata_elements_FloatPointDataObject>  floatData;
  std::vector<com_raytheon_uf_common_pointdata_elements_IntPointDataObject>  intData;
  std::vector<com_raytheon_uf_common_pointdata_elements_LongPointDataObject>  longData;
  int32_t size;
  std::vector<com_raytheon_uf_common_pointdata_elements_StringPointDataObject>  stringData;

  _com_raytheon_uf_common_pointdata_PointDataThriftContainer__isset __isset;

  void __set_floatData(const std::vector<com_raytheon_uf_common_pointdata_elements_FloatPointDataObject> & val) {
    floatData = val;
  }

  void __set_intData(const std::vector<com_raytheon_uf_common_pointdata_elements_IntPointDataObject> & val) {
    intData = val;
  }

  void __set_longData(const std::vector<com_raytheon_uf_common_pointdata_elements_LongPointDataObject> & val) {
    longData = val;
  }

  void __set_size(const int32_t val) {
    size = val;
  }

  void __set_stringData(const std::vector<com_raytheon_uf_common_pointdata_elements_StringPointDataObject> & val) {
    stringData = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_PointDataThriftContainer & rhs) const
  {
    if (!(floatData == rhs.floatData))
      return false;
    if (!(intData == rhs.intData))
      return false;
    if (!(longData == rhs.longData))
      return false;
    if (!(size == rhs.size))
      return false;
    if (!(stringData == rhs.stringData))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_PointDataThriftContainer &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_PointDataThriftContainer & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_PointDataThriftContainer &a, com_raytheon_uf_common_pointdata_PointDataThriftContainer &b);

typedef struct _com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint__isset {
  _com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint__isset() : constraintType(false), parameter(false), value(false) {}
  bool constraintType;
  bool parameter;
  bool value;
} _com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint__isset;

class com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint {
 public:

  static const char* ascii_fingerprint; // = "3368C2F81F2FEF71F11EDACDB2A3ECEF";
  static const uint8_t binary_fingerprint[16]; // = {0x33,0x68,0xC2,0xF8,0x1F,0x2F,0xEF,0x71,0xF1,0x1E,0xDA,0xCD,0xB2,0xA3,0xEC,0xEF};

  com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint() : constraintType(0), parameter(), value() {
  }

  virtual ~com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint() throw() {}

  int32_t constraintType;
  std::string parameter;
  std::string value;

  _com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint__isset __isset;

  void __set_constraintType(const int32_t val) {
    constraintType = val;
  }

  void __set_parameter(const std::string& val) {
    parameter = val;
  }

  void __set_value(const std::string& val) {
    value = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint & rhs) const
  {
    if (!(constraintType == rhs.constraintType))
      return false;
    if (!(parameter == rhs.parameter))
      return false;
    if (!(value == rhs.value))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint &a, com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint &b);

typedef struct _com_raytheon_uf_common_pointdata_PointDataRequestMessage__isset {
  _com_raytheon_uf_common_pointdata_PointDataRequestMessage__isset() : allLevels(false), constraints(false), levelParameter(false), levelValue(false), parameters(false), pluginName(false) {}
  bool allLevels;
  bool constraints;
  bool levelParameter;
  bool levelValue;
  bool parameters;
  bool pluginName;
} _com_raytheon_uf_common_pointdata_PointDataRequestMessage__isset;

class com_raytheon_uf_common_pointdata_PointDataRequestMessage {
 public:

  static const char* ascii_fingerprint; // = "781EA3AAB5B079D92C9DA7774B669520";
  static const uint8_t binary_fingerprint[16]; // = {0x78,0x1E,0xA3,0xAA,0xB5,0xB0,0x79,0xD9,0x2C,0x9D,0xA7,0x77,0x4B,0x66,0x95,0x20};

  com_raytheon_uf_common_pointdata_PointDataRequestMessage() : allLevels(0), levelParameter(), pluginName() {
  }

  virtual ~com_raytheon_uf_common_pointdata_PointDataRequestMessage() throw() {}

  bool allLevels;
  std::vector<com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint>  constraints;
  std::string levelParameter;
  std::vector<double>  levelValue;
  std::vector<std::string>  parameters;
  std::string pluginName;

  _com_raytheon_uf_common_pointdata_PointDataRequestMessage__isset __isset;

  void __set_allLevels(const bool val) {
    allLevels = val;
  }

  void __set_constraints(const std::vector<com_raytheon_uf_common_pointdata_PointDataRequestMessageConstraint> & val) {
    constraints = val;
  }

  void __set_levelParameter(const std::string& val) {
    levelParameter = val;
  }

  void __set_levelValue(const std::vector<double> & val) {
    levelValue = val;
  }

  void __set_parameters(const std::vector<std::string> & val) {
    parameters = val;
  }

  void __set_pluginName(const std::string& val) {
    pluginName = val;
  }

  bool operator == (const com_raytheon_uf_common_pointdata_PointDataRequestMessage & rhs) const
  {
    if (!(allLevels == rhs.allLevels))
      return false;
    if (!(constraints == rhs.constraints))
      return false;
    if (!(levelParameter == rhs.levelParameter))
      return false;
    if (!(levelValue == rhs.levelValue))
      return false;
    if (!(parameters == rhs.parameters))
      return false;
    if (!(pluginName == rhs.pluginName))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_pointdata_PointDataRequestMessage &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_pointdata_PointDataRequestMessage & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_pointdata_PointDataRequestMessage &a, com_raytheon_uf_common_pointdata_PointDataRequestMessage &b);



#endif