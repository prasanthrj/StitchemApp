package com.stitchemapp.daos;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.log4j.Logger;

import com.stitchemapp.api.IAuditDao;

public class GenericAuditJpaDao implements IAuditDao {


	protected EntityManager entityManager;
	public static final Logger LOGGER = Logger.getLogger(GenericJpaDao.class);
	
	/* Getters and Setters */
	
	public EntityManager getEntityManager() {
		return entityManager;
	}

	@PersistenceContext
	public void setEntityManager(EntityManager entityManager) {
		this.entityManager = entityManager;
	}



	
	
}
