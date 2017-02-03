//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2012.01.10 at 10:31:03 AM CST 
//


package org.isotc211._2005.gfc;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;
import org.isotc211._2005.gco.TypeNamePropertyType;


/**
 * Class that is used to describe the specifics of how a global feature attribute is bound to a particular feature type.
 * 
 * <p>Java class for FC_BoundFeatureAttribute_Type complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="FC_BoundFeatureAttribute_Type">
 *   &lt;complexContent>
 *     &lt;extension base="{http://www.isotc211.org/2005/gfc}FC_Binding_Type">
 *       &lt;sequence>
 *         &lt;element name="valueType" type="{http://www.isotc211.org/2005/gco}TypeName_PropertyType" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "FC_BoundFeatureAttribute_Type", propOrder = {
    "valueType"
})
public class FCBoundFeatureAttributeType
    extends FCBindingType
{

    protected TypeNamePropertyType valueType;

    /**
     * Gets the value of the valueType property.
     * 
     * @return
     *     possible object is
     *     {@link TypeNamePropertyType }
     *     
     */
    public TypeNamePropertyType getValueType() {
        return valueType;
    }

    /**
     * Sets the value of the valueType property.
     * 
     * @param value
     *     allowed object is
     *     {@link TypeNamePropertyType }
     *     
     */
    public void setValueType(TypeNamePropertyType value) {
        this.valueType = value;
    }

}