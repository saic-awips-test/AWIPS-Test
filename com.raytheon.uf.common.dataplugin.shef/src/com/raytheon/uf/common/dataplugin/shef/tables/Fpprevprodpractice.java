/**
* This software was developed and / or modified by Raytheon Company,
* pursuant to Contract DG133W-05-CQ-1067 with the US Government.
* 
* U.S. EXPORT CONTROLLED TECHNICAL DATA
* This software product contains export-restricted data whose
* export/transfer/disclosure is restricted by U.S. law. Dissemination
* to non-U.S. persons whether in the United States or abroad requires
* an export license or other authorization.
* 
* Contractor Name:        Raytheon Company
* Contractor Address:     6825 Pine Street, Suite 340
*                         Mail Stop B8
*                         Omaha, NE 68106
*                         402.291.0100
* 
* See the AWIPS II Master Rights File ("Master Rights File.pdf") for
* further licensing information.
**/
package com.raytheon.uf.common.dataplugin.shef.tables;
// default package
// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Fpprevprodpractice generated by hbm2java
 * 
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 17, 2008                        Initial generation by hbm2java
 * Aug 19, 2011      10672     jkorman Move refactor to new project
 * Oct 07, 2013       2361     njensen Removed XML annotations
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.1
 */
@Entity
@Table(name = "fpprevprodpractice")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Fpprevprodpractice extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private FpprevprodpracticeId id;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String productId;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String prodCateg;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String officeId;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double obsvalue;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date obstime;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double maxFcstvalue;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date validtime;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date basistime;

    public Fpprevprodpractice() {
    }

    public Fpprevprodpractice(FpprevprodpracticeId id) {
        this.id = id;
    }

    public Fpprevprodpractice(FpprevprodpracticeId id, String productId,
            String prodCateg, String officeId, Double obsvalue, Date obstime,
            Double maxFcstvalue, Date validtime, Date basistime) {
        this.id = id;
        this.productId = productId;
        this.prodCateg = prodCateg;
        this.officeId = officeId;
        this.obsvalue = obsvalue;
        this.obstime = obstime;
        this.maxFcstvalue = maxFcstvalue;
        this.validtime = validtime;
        this.basistime = basistime;
    }

    @EmbeddedId
    @AttributeOverrides( {
            @AttributeOverride(name = "lid", column = @Column(name = "lid", nullable = false, length = 8)),
            @AttributeOverride(name = "producttime", column = @Column(name = "producttime", nullable = false, length = 29)) })
    public FpprevprodpracticeId getId() {
        return this.id;
    }

    public void setId(FpprevprodpracticeId id) {
        this.id = id;
    }

    @Column(name = "product_id", length = 10)
    public String getProductId() {
        return this.productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    @Column(name = "prod_categ", length = 3)
    public String getProdCateg() {
        return this.prodCateg;
    }

    public void setProdCateg(String prodCateg) {
        this.prodCateg = prodCateg;
    }

    @Column(name = "office_id", length = 5)
    public String getOfficeId() {
        return this.officeId;
    }

    public void setOfficeId(String officeId) {
        this.officeId = officeId;
    }

    @Column(name = "obsvalue", precision = 17, scale = 17)
    public Double getObsvalue() {
        return this.obsvalue;
    }

    public void setObsvalue(Double obsvalue) {
        this.obsvalue = obsvalue;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "obstime", length = 29)
    public Date getObstime() {
        return this.obstime;
    }

    public void setObstime(Date obstime) {
        this.obstime = obstime;
    }

    @Column(name = "max_fcstvalue", precision = 17, scale = 17)
    public Double getMaxFcstvalue() {
        return this.maxFcstvalue;
    }

    public void setMaxFcstvalue(Double maxFcstvalue) {
        this.maxFcstvalue = maxFcstvalue;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "validtime", length = 29)
    public Date getValidtime() {
        return this.validtime;
    }

    public void setValidtime(Date validtime) {
        this.validtime = validtime;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "basistime", length = 29)
    public Date getBasistime() {
        return this.basistime;
    }

    public void setBasistime(Date basistime) {
        this.basistime = basistime;
    }

}